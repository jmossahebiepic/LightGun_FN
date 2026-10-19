# Regression checks

`python -m unittest discover -s tests -v` runs source contract and safe-export
checks. It does not compile or interpret Verse.

To run the actual pure-rule truth tables in UEFN:

1. Copy `fixtures/lightgun_rule_checks.verse` into project `Content` next to
   `lightgun_rules.verse`, then Build Verse.
2. Place `lightgun_rule_checks` once and launch a fresh game.
3. Require log `LightGunFN RULE TESTS: 40 passed, 0 failed`.
   There are 32 combinations of encounter source presence and 8 cover-state
   combinations; production calls the same pure functions.
4. Remove only the temporary test actor, then the copied Content source. Build
   and save again. Do not ship a test actor in the production map.

These tests do not spawn native NPCs or verify the full camera/HUD/end-round
pipeline. Complete the pending checks in `docs/VERIFICATION.md`.
