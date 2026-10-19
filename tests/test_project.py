"""Source contract/export checks. These do NOT replace Verse runtime tests."""
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import tempfile
import unittest
import zipfile

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "exporter", ROOT / "tools/export_source_starter.py")
exporter = importlib.util.module_from_spec(spec)
spec.loader.exec_module(exporter)


def source(name):
    return (ROOT / "Content" / name).read_text(encoding="utf-8-sig")


class SourceContract(unittest.TestCase):
    def test_all_editables_have_tooltips(self):
        for name in exporter.SOURCES:
            text = source(name)
            blocks = re.findall(r"(?m)^\s*@editable[^\n]*\n((?:        [^\n]*\n)*)", text)
            for block in blocks:
                self.assertIn("ToolTip :=", block, name)
            self.assertEqual(len(blocks), len(re.findall(r"(?m)^\s*@editable", text)), name)

    def test_no_route_index_fallback(self):
        ctrl = source("lightgun_controller.verse")
        enc = source("lightgun_encounter.verse")
        self.assertIn("FallbackStandingTarget(Station.CameraProfile)", ctrl)
        self.assertIn("FallbackCoverTarget(Station.CameraProfile)", ctrl)
        self.assertNotIn("StationIndex", enc)
        self.assertIn("Owner.ClaimGuardProfile(GuardProfile)", enc)

    def test_all_encounter_sources_reach_shared_rule(self):
        enc = source("lightgun_encounter.verse")
        self.assertIn(
            "LightgunHasEncounterSources(ResolvedGuardSpawners.Length, NPCSpawners.Length, "
            "CreatureSpawners.Length, CreaturePlacers.Length, PracticeTargets.Length)", enc)
        self.assertIn("ExpectedEliminations > 0 and not HasSources?", enc)

    def test_terminal_hud_guards(self):
        text = source("lightgun_controller.verse")
        for name in ("RefreshObjectiveHud", "RefreshHud"):
            body = text.split(f"    {name}(Player : player) : void=", 1)[1].split("\n    ", 1)
            # Search up to the first actual HUD lookup, retaining nested lines.
            prefix = text.split(f"    {name}(Player : player) : void=", 1)[1].split("if (Hud", 1)[0]
            self.assertIn("if (SessionEnded?):\n            return", prefix)

    def test_cover_entry_rule_and_single_arrival_refill(self):
        text = source("lightgun_controller.verse")
        self.assertIn("LightgunShouldReloadOnCover(WasCovered, true", text)
        self.assertIn("ApplyDesiredCover(Agent, ?AllowReload := logic{not Station.ReloadOnArrival?})", text)
        begin = text.split("    BeginRouteTravel() : void=", 1)[1].split("    EndRouteGraceAfterDelay", 1)[0]
        self.assertNotIn("StopDucking(Agent)", begin)
        self.assertIn("ApplyStandingCamera(Agent)", begin)
        self.assertNotIn("GetInputEvents(WeaponSecondary)", text)

    def test_regression_fixture_contains_all_40_cases(self):
        text = (ROOT / "tests/fixtures/lightgun_rule_checks.verse").read_text()
        self.assertEqual(len(re.findall(r'Check\("sources_', text)), 32)
        self.assertEqual(len(re.findall(r'Check\("cover_', text)), 8)

    def test_private_descriptors_ignored(self):
        ignore = (ROOT / ".gitignore").read_text()
        for name in ("LightGunFN.uefnproject", "LightGunFN.uplugin"):
            self.assertIn("/" + name, ignore)


class SourceExport(unittest.TestCase):
    def test_allowlist_and_hashes(self):
        with tempfile.TemporaryDirectory() as d:
            path = Path(d) / "source.zip"
            exporter.export(path)
            with zipfile.ZipFile(path) as z:
                self.assertEqual(set(z.namelist()), set(exporter.ALLOWLIST) | {"SOURCE_MANIFEST.json"})
                manifest = json.loads(z.read("SOURCE_MANIFEST.json"))
                for name, sha in manifest["sha256"].items():
                    self.assertEqual(hashlib.sha256(z.read(name)).hexdigest(), sha)
                    self.assertNotIn(b"\r\n", z.read(name))
                self.assertFalse(any(n.endswith((".uasset", ".umap", ".uplugin", ".uefnproject")) for n in z.namelist()))

    def test_no_overwrite(self):
        with tempfile.TemporaryDirectory() as d:
            path = Path(d) / "source.zip"
            path.write_bytes(b"existing")
            with self.assertRaises(FileExistsError):
                exporter.export(path)
            self.assertEqual(path.read_bytes(), b"existing")

    def test_reject_unexpected_identity(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            for name, data in exporter.collect().items():
                p = root / name
                p.parent.mkdir(parents=True, exist_ok=True)
                p.write_bytes(data)
            p = root / exporter.ALLOWLIST[0]
            p.write_bytes(p.read_bytes() + b'\n# C:/private/source\n')
            with self.assertRaisesRegex(ValueError, "Sensitive-content"):
                exporter.collect(root)


if __name__ == "__main__":
    unittest.main()
