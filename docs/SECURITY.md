# Identity, automation and scanning

Bound `LightGunFN.uefnproject`/`LightGunFN.uplugin` files are no longer tracked.
They remain in the original authorized author's local checkout and backup.
The current source manifest no longer publishes an absolute source-project path.

New creators use UEFN Project Browser for their own identity. Never paste another
account's IDs, rename serialized classes or replace UUIDs in binary packages.
The allowlisted source ZIP avoids identity-bearing descriptors and map packages.

**History warning:** commit `d637c94` still contains the earlier project/module
IDs and account-scoped namespace. Forward commits cannot remove already-published
history, forks or caches. These identifiers are not authentication credentials.
A coordinated history rewrite needs separate explicit approval; none was done.

Public exports contain no Python/MCP-enable settings. These are optional editor
tools, not gameplay prerequisites. The author's local settings may remain enabled.
If opting in, understand that MCP can control/edit the project, verify its identity,
keep the listener local, and protect access. A tool/version-specific serialization
failure is not a universal platform limitation.

The d637c94 audit found no matches for the tested credential patterns in 69 files.
Binary printable-string scanning is not full deserialization or certification
against confidential/unknown-format data. Review provenance before redistribution.

Never submit a discovered credential in a public issue. Rotate actual secrets at
the issuer first, then coordinate history cleanup. Do not commit authentication,
logs, caches or local backups.
