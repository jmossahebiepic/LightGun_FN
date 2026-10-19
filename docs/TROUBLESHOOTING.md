# Troubleshooting

## Startup
- **Missing pointer APIs:** check target version/feature support. Editor
  Python/MCP does not fix a gameplay API error.
- **No HUD/view:** check the log, one manager, START and distinct camera roles.
- **Missing targets:** ExplicitOnly needs two assigned cameras. A supplied
  CameraProfile needs exactly one correctly tagged camera per role.
- **Duplicate native-device tag:** remove copied Verse markup from the duplicate
  or explicitly rewire. Actor Tags are not Verse tags.
- **Guard profile claimed twice:** use only one encounter per RangeA/RangeB group.
  Copies should use ExplicitOnly and independent spawners.
- **No native spawners/practice targets:** assign at least one supported source
  or disable automatic completion.

## Input
- **Space does nothing:** bind Fortnite Jump to Space; check pedal mapping outside
  the editor. The code reads actions, not raw keys.
- **Right-click does nothing:** expected; manual reload was removed.
- **Cover will not refill:** ReloadOnCover must be on; transition from exposed.
  Keeping cover through travel does not refill again.
- **No shot in cover/travel:** expected, as is rejection of invalid pointers.
- **Rejected edge clicks:** inspect DebugPointer, guide marks, normalization
  scales/offsets and deadzone. Coordinate validity is not USB tracking detection.

## Combat / route
- **No enemy:** check arrival activation, native enable state, correct arrays/
  GuardProfile, finite limits, NPC definition, navigation and native diagnostics.
- **Never clears:** full-wave ExpectedEliminations must match actual spawns.
  Failed/delayed spawns are not kills. There is no general spawn-timeout recovery UI.
- **Wrong view/wave after duplication:** choose ExplicitOnly, remove copied
  fallback tags and assign all copied references explicitly.
- **Tiny targets:** adjust enemy distance and matching live/target FOV. Do not
  inflate meshes to conceal an untested aiming/camera mismatch.
- **No enemy damage:** inspect proxy with HidePlayerPawn off; check team, sight
  line, loadout and MakePlayerInvulnerable. Camera visibility alone is insufficient.
- **Bad result/replay:** test native death and End Game devices with actual teams,
  then a fresh round. Route looping does not reset encounters.

## Optional editor automation

Verify active project and current schema. In the tested shipping UEFN build,
Python did not accept Unreal Cmd console commands; do not repeatedly paste those
commands into Python. Use supported UEFN settings for MCP.

Other editors may hold the same port. Verify listener identity. Never force-close
unrelated projects or discard unsaved changes. Keep control endpoints local and
disable automation when not needed.
