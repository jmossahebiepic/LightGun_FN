# LightGunFN agent guide

## Scope

This repository is one single-player UEFN lightgun starter. Preserve the
working S00 → S01 → S02 example and keep theme-specific Hoth content out.
Read `README.md` before changing code or placed devices.

## Source map

- `Content/lightgun_controller.verse`: input, cover/reload, combat, cameras,
  route execution, HUD state, player proxy and round lifecycle.
- `Content/lightgun_pointer_input.verse`: Virtual Pointer deprojection and the
  LUF-to-XYZ type boundary. Keep this isolation.
- `Content/lightgun_route.verse`: START, station settings, targets and travel.
- `Content/lightgun_encounter.verse`: spawner activation, target tracking and
  explicit elimination counts.
- `Content/lightgun_practice_target.verse`: neutral shootable prop adapter.
- `Content/lightgun_hud.verse`: asset-free, non-interactive HUD.
- `Content/lightgun_template_tags.verse`: native-device fallback tags for the
  supplied three-stop map.
- `Content/lightgun_game_manager.verse`: creator-facing subclass. New maps
  place this class; keep `lightgun_controller` for serialized compatibility.

## Non-negotiable contracts

- One player, one `lightgun_game_manager`, one START.
- Trigger/left mouse fires. Fortnite Jump (Space or a bound pedal) toggles
  cover and reloads on entry. There is no independent manual reload input.
- START is route index 0 and never appears in its own `CombatStations`.
- Live cameras move. Station cameras are transform-only authoring targets.
  Every Fixed Point Camera has **Add to Players on Start = Off**.
- Explicit editable references take precedence. Fixed tags only reproduce the
  supplied S00/S01/S02 map; new stations use explicit camera/encounter arrays.
- A tagged native actor needs `VerseTagMarkupComponent.InternalTags`; adding
  an ordinary Unreal Actor Tag is insufficient.
- Each native spawner belongs to one encounter. Arrival-only spawners start
  disabled and use finite spawn limits.
- Automatic progression requires a positive `ExpectedEliminations` covering
  the full authored wave. Never infer completion from a temporary live count
  of zero.
- Route looping is not a round reset. Leave `LoopRoute` false in the example.
- Do not rename serialized Verse classes merely for cleanup.

## Editing workflow

1. Confirm the active UEFN project and map are `LightGunFN`.
2. Use UEFN catalog placement for Creative devices; raw Blueprint spawning can
   produce actors that Verse cannot reference.
3. Build Verse after every source change and fix all error diagnostics.
4. Save the level plus all OFPA external actors/objects.
5. Launch a fresh play session. Require all three “station ready” messages and
   the final “configured” message with no setup/runtime errors.
6. Test fire, cover/reload, stand, two-enemy clear, three-enemy clear, defeat,
   victory and a second fresh round.
7. Re-test the actual gun, pedal, resolution and display scaling for input or
   camera changes.

## Safety and limitations

- Current hit selection is point-radius and nearest accepted depth; it is not a
  mesh trace and does not test wall occlusion. Keep targets in open lanes.
- Virtual Pointer support and publishing eligibility must be rechecked against
  the target UEFN/Fortnite release. Do not promise publishability from a local
  build.
- Keep project identity, `.uefnproject`, map, `__ExternalActors__` and
  `__ExternalObjects__` together. A `.umap` alone is not a backup.
- Never commit `.lore/`, `.codex-backup/`, `Saved/`, `Intermediate/` or local
  workspace/editor files.
