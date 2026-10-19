# Add a combat station — no Verse edit

**Purpose:** one stop that owns its own views and finite enemy group.

## Select / change

1. Place a `lightgun_station` and `lightgun_encounter`; label them
   `LG_MyStation` and `LG_MyEncounter`.
2. Add `LG_MyShootTarget`/`LG_MyCoverTarget` Fixed Point Cameras, auto-add off,
   FOV matching the LIVE cameras. Frame both views; only transforms are copied.
3. On the station choose **CameraProfile = ExplicitOnly**, assign its targets,
   and set `StationName = My station`.
4. Set `Encounters = [LG_MyEncounter]`, `AdvanceWhenEncountersComplete = true`,
   `TravelDuration = 2`, `ReloadOnArrival = false`.
5. Add one native Guard Spawner in a clear lane on Team 2. Turn Enabled at Game
   Start off, Infinite Spawn off, one active guard, one lifetime spawn, no timer
   respawning. Disable patrol for the first test; author health/loadout.
6. On the encounter choose **GuardProfile = ExplicitOnly**; assign the spawner
   in `GuardSpawners`, `SpawnOnFirstArrival = true`, `ExpectedEliminations = 1`.
7. Append the station to START's `CombatStations`. Never append START, repeat a
   station or assign one spawner to two encounters.
8. Assign distinct native victory/failure End Game devices on the manager and
   configure fresh-round behavior. Validate the losing result with real teams;
   selecting an empty winning team is not proof that failure will end the round.

## Try / expect

Build, save, fresh round. Finish the input check. Expect travel to your new view
and exactly one guard. Cover refills; stand to fire. Its elimination requests
victory if this is the final station. Check both views and enemy access to the
exposed hidden proxy, not just the camera.

## Reset

Remove your station from START's array first, then remove only your new kit.
Restore any edited manager references. Start a fresh round.

## Duplicate the supplied Range A/B

Duplicate station, targets, encounter and spawners together. Rename the copies.
Set **both copied profiles to ExplicitOnly** and explicitly assign every new
reference. Remove copied Verse tag markup from copied native devices, or the
original lookup can become ambiguous/include the new wave.
Clear/replace copied inputs, triggers and arrival waypoints; update the full-wave
count and append only the new station. Folders do not parent or rewire actors.

Correctly profiled Range A/B can now be reordered in START: selection stays with
the device profile instead of the route index.

## Optional additions

- Place `lightgun_route_waypoint` on a clear path and add it to the **destination**
  station. Travel is eased straight segments, not collision avoidance.
- NPC Spawners, Creature Spawners and Creature Placers now count as valid setup
  sources even without guards/props. Use the corresponding array and finite native
  settings. Forced attack applies only to guards. The validation fix is not proof
  that a custom NPC definition attacks correctly or is portable.
