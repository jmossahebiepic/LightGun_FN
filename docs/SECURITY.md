# Identity, automation and scanning

Bound `LightGunFN.uefnproject`/`LightGunFN.uplugin` files remain local and ignored.
New creators must obtain their own identity through UEFN Project Browser, not
reuse another account's identifiers or edit UUIDs in binary packages.

## Authorized history cleanup — 19 October 2026

Published main was rewritten to remove the bound descriptors from every reachable
commit and remove the absolute source-project path from historical manifests.
The known project/module IDs, account-scoped namespace and source path were
checked in all reachable blobs in both UTF-8 and UTF-16 encodings.

This is a Git-history cleanup, not a promise of erasure from GitHub retention,
cached commit URLs, forks or existing clones. If old content is still accessible,
the repository owner may need to contact GitHub Support. These identifiers were
not authentication credentials; no account compromise is established.

Private recovery bundles and local bound descriptors are deliberately retained
outside tracked content. Never push them, old refs or an old clone back into this
repo. Collaborators should follow MIGRATION.md and re-clone rather than merge old
history, which could reintroduce removed data.

## Automation and release scope

Source exports contain no Python/MCP-enable settings; these are optional editor
tools, not gameplay prerequisites. Local author settings may remain enabled.
Verify active project and listener identity, keep control endpoints local and
protect access. Version-specific tool failures are not platform guarantees.

The initial audit found no matches for the credential patterns tested. Binary
printable-string scans are not full deserialization or security certification.
Check provenance before redistribution and respect RIGHTS.md.

Never post a credential in a public issue. If an actual secret is discovered,
revoke/rotate it at its issuer before coordinating historical cleanup.
