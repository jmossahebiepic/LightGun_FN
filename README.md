# LightGunFN — Lightgun Lab

A small single-player UEFN onboarding example for a mouse-emulating lightgun and keyboard-emulating foot pedal.

## Working loop

1. **S00 Input Test** — fire once, press Space or the pedal to enter cover and reload, then press it again to stand.
2. **S01 Range A** — clear two finite guard spawners; the route advances automatically.
3. **S02 Range B** — clear three guards; the round ends in victory.

Controls:

- Trigger / left mouse: fire.
- Space bar or pedal / Fortnite Jump action: toggle cover and reload on entry; this is the only normal reload mechanic.
- Mouse and keyboard use the same gameplay path.

## Built map

The `LightGunFN` map now contains:

- One `lightgun_game_manager`, START and two combat stations.
- Two live Fixed Point Cameras and six station target cameras.
- Two arrival-only encounters with two and three finite guards.
- Victory and defeat End Game devices configured to end the round.
- A neutral room blockout with side/end walls and low foreground cover.
- Six-round magazine, untimed practice, onboarding checklist and remaining-enemy HUD.

Native device discovery uses `VerseTagMarkupComponent` tags declared in `lightgun_template_tags.verse`. Explicit editable references remain supported and preferred for creator-authored extensions.

For repository structure, invariants and the required agent workflow, read
[`AGENTS.md`](AGENTS.md) before modifying Verse or placed devices.

## Important settings

- `LoopRoute = false`; replay is a fresh round.
- `ReloadOnCover = true`; entering cover reloads once and standing does not. There is no independent manual reload input.
- Camera `Add to Players on Start = false`; Verse owns the active camera stack.
- All live/target cameras use a 55 degree FOV and guards sit roughly 14.5 m from each firing camera for larger silhouettes.
- Every guard spawner is disabled at game start, has one active guard and a lifetime limit of one.
- S01 `ExpectedEliminations = 2`; S02 `ExpectedEliminations = 3`.
- Guard team is Team 2; the player is expected on Team 1.
- Project matchmaking maximum is one player.

## Verified on 19 October 2026

- Verse build completed with no diagnostics.
- A UEFN play session started successfully.
- Runtime log reported all three stations ready and the controller configured.
- Route order, encounter references/counts, camera FOV/start behaviour and finite guard settings were read back after saving.

Physical lightgun/pedal input, actual guard combat, all three checklist inputs and final victory should be rechecked after gameplay or device-layout changes.

## Targeting boundary

Current targeting chooses the nearest accepted target depth using a point-radius test. It is not a mesh-accurate or wall-occluded trace. Keep targets in the supplied open lanes and treat this as an experimental open-lane prototype until stronger targeting is implemented and verified.
