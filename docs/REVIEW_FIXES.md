# Review disposition

- **C1 fixed in source:** validation includes guards, NPCs, creatures, placers and
  practice props via a shared pure rule. Native custom-AI tests remain pending.
- **C2 fixed in source/map:** camera and guard profiles belong to devices; route
  index no longer selects them. Ambiguous camera/end tags and duplicate guard
  fallback claims fail. Explicit native reference uniqueness is still an editor
  check (native Verse wrappers are not comparable).
- **C3 corrected:** verification separates the 13 October runtime evidence from
  the 19 October compile and the current attempts; no fresh runtime pass claimed.
- **C4 corrected:** tooltips describe ExplicitOnly versus profile lookup.
  MCP limitations are scoped to the observed tooling rather than a platform rule.
- **C5 fixed in source:** both gameplay HUD refresh methods exit after terminal
  state, preserving the result objective.
- **C6 fixed in source:** cover reload checks an exposed-to-covered edge,
  preserves logical cover during travel, and suppresses a second arrival refill.
- **Identity exposure reduced in the new revision:** descriptors remain local,
  not tracked; absolute provenance path removed; allowlisted source exporter
  excludes descriptors/automation flags/assets. Historical identifiers remain.
- **Reuse ambiguity clarified, not licensed:** RIGHTS.md explicitly grants no
  open-source rights pending ownership and license approval. Asset terms require
  separate review. No legal approval is implied.
- **Junior guidance added:** first run, independent project creation, station
  duplication, troubleshooting and safe migration. Independent-user and hardware
  acceptance tests remain open.

See VERIFICATION.md for actual test outcomes. Source fixes and an honest handoff
are not equivalent to a fully validated public/template release.
