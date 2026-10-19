# LightGunFN — Lightgun Lab

**Experimental independent learning prototype. Not an official Epic sample,
certification or publishing-ready template.**

- **Trigger / left mouse:** fire.
- **Fortnite Jump (Space by default) / pedal:** enter cover and reload; press
  again to stand. There is no separate manual reload key.

Reference loop: **input practice → two guards → three guards → finish**.
Mouse/keyboard uses the same path as mouse-/keyboard-emulating hardware.

## Start here

1. Read [rights and dependencies](RIGHTS.md) before using or redistributing.
2. Follow [first run](docs/FIRST_RUN.md). This revision is **source-first**,
   not a bound project that any account can launch unchanged.
3. Follow [add a station](docs/ADD_A_STATION.md), then
   [troubleshooting](docs/TROUBLESHOOTING.md) if the result differs.

Authorized collaborators can use the original local project and private
descriptors, which are no longer tracked. The map and OFPA packages are
historical/reference authoring assets, **not a certified portable starter**.
Before pulling into an older bound checkout, read [migration](docs/MIGRATION.md)
and back up its descriptors; Git can remove formerly tracked files on update.

## Wiring

- The manager references START, which owns `CombatStations`.
- A station's `CameraProfile` owns its optional fallback, not its route index.
  Explicit target references take precedence.
- An encounter's `GuardProfile` owns its optional tagged group; different
  encounters cannot claim the same fallback group.
- New stations and encounters default to `ExplicitOnly`.
- Native tags require **VerseTagMarkupComponent**, not Actor Tags.
- Reference FOV is 55°, guard distance about 14.5 m, and magazine size 6.
  These are examples, not universal hardware calibration.

## Reload contract

Exposed-to-covered reloads once. Remaining covered through travel does not.
If the final cover state changes from exposed during travel, apply it once on
arrival. `ReloadOnArrival` performs one refill and suppresses a simultaneous
cover refill. Standing does not reload.

Keep `LoopRoute = false`; a route loop is not a reset. Positive
`ExpectedEliminations` must cover the full authored wave; 0 means manual
progression. Incorrect counts or failed spawns can stall a round.

## Safe source handoff

With Python 3.10+:

```shell
python -m unittest discover -s tests -v
python tools/export_source_starter.py --output dist/LightGunFN-source.zip
```

The allowlisted ZIP includes Verse and guides, not bound descriptors, UAssets,
editor caches, local paths or Python/MCP-enable settings. Credential-pattern
checks are a safeguard, not a security certification. The handoff is
subject to RIGHTS.md and is not a turnkey playable island.

## Limits and evidence

Read [dated verification/open gates](docs/VERIFICATION.md). Compilation and startup
do not prove combat, hardware, victory/defeat/replay or an independent first run.
Targeting is nearest accepted depth around an aim point, not mesh-accurate or
wall-occluded. Use open lanes. Explicit native-reference uniqueness remains an
editor check because those Verse wrappers are not comparable.

Agents: [AGENTS.md](AGENTS.md). Identity/automation: [SECURITY.md](docs/SECURITY.md).
