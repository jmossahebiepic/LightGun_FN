# Dated verification and remaining gates

## 13 October 2026 — historical authoring
- Original bound project compiled and launched a session.
- Logs showed S00/S01/S02 ready and controller configured.
- Camera, route and guard settings were read back.
- The user screenshot showed Range A combat.
- Not an independent new-account clone, formal full-loop test or hardware profile.

## 19 October 2026 — earlier tooltip pass
- Source compilation succeeded on project open.
- The README previously grouped older runtime evidence under this date.
  That blanket dated verification claim is withdrawn.

## Review fixes

Code addresses all-source validation, device-owned profiles, ambiguous tag/group
detection, terminal HUD guards and edge-triggered cover reload. Python source/
export tests do not execute Verse. The fixture under `tests/fixtures` must run in
UEFN for actual VM rule verification. Completed run results are appended below.

## Remaining release gates
- Rights holder confirms ownership/authority and approves the code license;
  platform assets receive separate provenance/redistribution review.
- A new account creates, builds and wires its own project from these guides alone.
- NPC-only, creature-only and placer-only native waves spawn/register/clear;
  pure source-count tests do not prove native AI behavior.
- Guard damage, invalid/edge pointer input, input during travel, HUD toggling.
- Actual victory/defeat team behavior, native elimination, repeated fresh rounds
  without stale cameras, subscriptions, ammo or encounters.
- Hardware profile: gun, pedal, driver, display, resolution/scaling, bindings and
  exact UEFN/Fortnite build recorded; no complete profile is certified yet.
- Three uninvolved juniors can open, run and add a station without author help.
- Current experimental input/publishing eligibility and asset dependencies checked.

Until those gates close, this remains an experimental source learning prototype,
not junior-ready, universally compatible or publishing-approved.

## 19 October 2026 — review-fix run

- Final production Verse compilation: zero error/warning diagnostics via
  `ValkyrieToolset.VerseToolset.BuildAll`.
- Temporary 40-case rule fixture: compiled successfully but **not executed**.
  Two session-launch calls timed out at 120/300 seconds; subsequent state was
  Disconnected. UEFN logged `matchmaking.unknown_session` during the attempts.
  No `LogVerse` pass result was produced. Fixture actor/source removed afterward.
- Map migration: five actors received the explicit camera/guard profiles.
  Reversing the combat array in the editor preserved each actor's profile and
  encounter references on read-back. The original order was restored and saved.
  This is serialization evidence, not runtime traversal proof.
- Ten Python source-contract/export tests passed. They include tooltip coverage,
  all-source validation wiring, terminal guards, reload call structure, profile
  ownership, ZIP allowlist/hash integrity and rejection of identifying paths.
- Source changes and the mapped profiles are saved. The final production map
  contains no temporary rule-test actor.
