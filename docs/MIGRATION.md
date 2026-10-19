# Updating an existing bound checkout

This revision deliberately stops tracking `LightGunFN.uefnproject` and
`LightGunFN.uplugin`. **Before pulling into another existing checkout**, save
UEFN and back up the entire project, including those two descriptors, outside
the checkout. Git may remove formerly tracked descriptors during the update.
Restore your own descriptors from that backup afterward; they are now ignored.
Never restore someone else's IDs into a new account's project.

The author's working checkout was preserved in place during this change, and
original descriptors/source have a local ignored backup. That local backup is
not part of the public repository.

## Existing map profiles

The reference map's five changed OFPA packages record:

- `LG_S00_START.CameraProfile = InputBay`
- `LG_S01_Station.CameraProfile = RangeA`
- `LG_S02_Station.CameraProfile = RangeB`
- `LG_S01_Encounter.GuardProfile = RangeA`
- `LG_S02_Encounter.GuardProfile = RangeB`

If applying source fixes to an independently customized map, set these profiles
only on the corresponding original example actors, or use `ExplicitOnly` and
assign the native devices in Details. New devices default to ExplicitOnly.
Do not replace custom actors with the reference binaries merely to get profiles.

Old serialized Verse classes/property names are preserved. Build Verse and
inspect your reference graph after migration. The two combat stations remain
in the original Range A then Range B order; a temporary reorder check was restored.

## Public reuse

New users follow FIRST_RUN.md to create a fresh project through UEFN and wire the
source-only handoff. Historical map packages are not a guaranteed independent
clone. Read RIGHTS.md before using any source or asset.
