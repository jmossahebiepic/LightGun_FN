"""Export an allowlisted, LF-normalized source handoff; never edit UEFN identity."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import zipfile

ROOT = Path(__file__).resolve().parents[1]
SOURCES = (
    "lightgun_controller.verse", "lightgun_encounter.verse",
    "lightgun_game_manager.verse", "lightgun_hud.verse",
    "lightgun_pointer_input.verse", "lightgun_practice_target.verse",
    "lightgun_route.verse", "lightgun_template_tags.verse", "lightgun_rules.verse",
)
DOCS = ("README.md", "AGENTS.md", "RIGHTS.md", "docs/FIRST_RUN.md",
        "docs/ADD_A_STATION.md", "docs/TROUBLESHOOTING.md", "docs/SECURITY.md",
        "docs/VERIFICATION.md", "docs/MIGRATION.md", "docs/REVIEW_FIXES.md")
ALLOWLIST = tuple("Content/" + n for n in SOURCES) + DOCS
SENSITIVE = (
    rb"(?i)[A-Z]:[\\/]",  # No absolute Windows paths in the source handoff.
    rb"(?i)@[a-z0-9.-]*fortnite\.com",
    rb'(?i)"(?:projectId|projectVersePath|bEnablePythonForProject|bEnableToolsetsForProject)"\s*:',
    rb"(?:gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,})",
    rb"-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----",
)


def collect(root=ROOT):
    root = Path(root).resolve()
    result = {}
    for name in ALLOWLIST:
        path = root / name
        if path.is_symlink() or root not in path.resolve().parents:
            raise ValueError(f"Refusing path outside source root: {name}")
        data = path.read_bytes().replace(b"\r\n", b"\n")
        if any(re.search(pattern, data) for pattern in SENSITIVE):
            # Name only: never repeat a credential in logs.
            raise ValueError(f"Sensitive-content check failed: {name}")
        result[name] = data
    manifest = {
        "format": 1, "kind": "restricted source handoff, not a playable island",
        "lineEndings": "LF", "rights": "See RIGHTS.md; no license grant",
        "sha256": {n: hashlib.sha256(b).hexdigest() for n, b in result.items()},
    }
    result["SOURCE_MANIFEST.json"] = (json.dumps(manifest, indent=2) + "\n").encode()
    return result


def export(output, root=ROOT):
    data = collect(root)  # Validate all inputs before creating any output.
    output = Path(output).resolve()
    if (Path(root).resolve() / "Content") in output.parents:
        raise ValueError("Write exports outside UEFN Content")
    if output.exists():
        raise FileExistsError(f"Refusing to overwrite existing export: {output.name}")
    output.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(output, "x", zipfile.ZIP_DEFLATED) as z:
        for name, content in sorted(data.items()):
            info = zipfile.ZipInfo(name, date_time=(2026, 10, 19, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o100644 << 16
            z.writestr(info, content)
    return len(data)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    print(f"Exported {export(args.output)} files to {args.output}; see RIGHTS.md")
