# Agent guide — entire repository

Read README.md, RIGHTS.md and docs/VERIFICATION.md. This is an independent
experimental learning prototype, not an official Epic product or cleared release.

## Source map
- `Content/lightgun_game_manager.verse`: creator-facing class. Preserve its
  `lightgun_controller` base and all serialized class/property identities.
- `lightgun_controller.verse`: input, camera rig, hidden proxy, route, lifecycle.
- `lightgun_pointer_input.verse`: LUF deprojection boundary; never mix its vectors
  with the controller's XYZ imports.
- `lightgun_route.verse`: station-owned CameraProfile and travel settings.
- `lightgun_encounter.verse`: encounter-owned GuardProfile and wave bookkeeping.
- `lightgun_rules.verse`: pure rules used by gameplay and the regression fixture.
- HUD, practice_target and template_tags files: presentation, prop targets and
  optional native-device lookup.

## Contracts
- One player/manager/START. START never appears in its own combat list.
- Pointer fires. Jump/Space/pedal controls cover/reload. No manual reload key.
- Reload on exposed-to-covered entry, not repeated camera application.
- Preserve logical cover in travel. ReloadOnArrival prevents a double refill.
- Never refresh gameplay HUD after the session ends.
- Validate all five encounter source kinds; completion uses a full-wave count.
- Explicit references win. Profiles follow devices, not route indices.
- Native lookup needs VerseTagMarkupComponent; ambiguous camera/end tags fail.
- Guard fallback groups are exclusive to an encounter. Explicit native reference
  uniqueness must be checked in the editor too.
- Camera targets supply transforms only; live cameras move; auto-add flags off.
- Preserve open lanes; no mesh-hit or wall-occlusion claim.

## Workflow
1. Verify active project/map and local changes; discover current tool schemas.
2. Prefer catalog placement. A particular MCP reference-write failure does not
   prove placement is wrong. Use editor Details for explicit references.
3. Build Verse after source edits and record actual diagnostics/build version.
4. Run Python tests. Run the fixture under `tests/fixtures` in UEFN as documented;
   remove its temporary actor and Content source before shipping the map.
5. Save OFPA packages with the map; test a fresh round after gameplay edits.
6. Report pending hardware, losing-team, reset and junior-usability checks.
   Never re-date historical tests or equate a compile with a playthrough.

## Publishing
- Bound descriptors are local-only; do not unignore or publish them.
- Do not rewrite IDs/binaries to simulate a new project. Use the source export.
- No local caches, logs, editor automation preferences or absolute source paths.
- Published history was sanitized on 19 October 2026. Never restore old
  refs or recovery bundles. Further rewrites require explicit authorization;
  identifiers are not authentication credentials.
- Do not grant an open-source license or clear platform assets without the
  rights holder's authority. Keep unresolved release gates explicit.
