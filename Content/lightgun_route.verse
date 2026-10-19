using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Verse }

LG_GuideCategory_lightgun_route<localizes> : message = "00 - Device Guide"

# Localised UEFN Details-panel help; no gameplay logic below is changed.
LG_Description_lightgun_route_waypoint<localizes> : message = "Optional travel handle. Position and rotate this device, then add it to the destination station ArrivalWaypoints in order. No editable settings: its transform guides travel, not an automatically collision-avoiding spline. This guide is informational only; changing its text does not affect gameplay."
LG_Description_lightgun_station<localizes> : message = "A combat stop with independent shooting/cover views, encounters and progression inputs. Its transform is the rig destination; ArrivalWaypoints and travel settings describe the approach into this stop. This guide is informational only; changing its text does not affect gameplay."
LG_Tip_lightgun_station_StationName<localizes> : message = "Readable station name used in setup diagnostics. Naming this field does not rename the Outliner actor or change route order; order comes from START CombatStations."
LG_Tip_lightgun_station_AdvanceInput<localizes> : message = "Optional Input Trigger that advances only while this is the current station. Configure/enable the native device and bind its Creative Input Action in Fortnite. Do not also bind the same input through AdvanceTrigger."
LG_Tip_lightgun_station_AdvanceTrigger<localizes> : message = "Optional Trigger for advancing from this station only. Connect a button, timer or other device to it. Requests at inactive stations or during travel are ignored."
LG_Tip_lightgun_station_Encounters<localizes> : message = "Encounters belonging to this stop. Each activates once on first arrival and supplies shootable targets while this station is current. Shared encounter references do not reset waves. Every native spawner must belong to one encounter only."
LG_Tip_lightgun_station_PlayerTargetHeightOffset<localizes> : message = "Station-specific world-Z adjustment in centimetres for the hidden player pawn enemies aim at. Positive raises it above railings; negative lowers it. Does not move cameras, the station marker or NPCs. Default 0; verify enemy sight lines."
LG_Tip_lightgun_station_StandingCameraTarget<localizes> : message = "Required authoring Fixed Point Camera for the shooting view at this station. Assign a separate actor, not either LIVE camera. Add to Players on Start must be off. Position/rotation are cached; FOV and other camera settings are not copied."
LG_Tip_lightgun_station_DuckedCameraTarget<localizes> : message = "Required authoring Fixed Point Camera for the cover view. Position it independently from the shooting target. Keep it separate from both LIVE cameras and off the player camera stack. Only its transform is copied."
LG_Tip_lightgun_station_AdvanceWhenEncountersComplete<localizes> : message = "Automatically request advancement when all assigned encounters reach their positive ExpectedEliminations counts. Empty encounter lists or any zero-count encounter will not auto-advance. Include delayed enemies in each full-wave count."
LG_Tip_lightgun_station_ArrivalWaypoints<localizes> : message = "Optional lightgun_route_waypoint devices in travel order from the previous stop to THIS destination. Empty means direct travel. Their transforms guide rig/camera movement; paths are eased straight segments, not collision-aware splines."
LG_Tip_lightgun_station_TravelDuration<localizes> : message = "Total desired approach duration in seconds; minimum 0.05. Applies to travel into this station, not a wait after arriving. Allow enough time and space for all waypoint segments."
LG_Tip_lightgun_station_RouteEasing<localizes> : message = "How travel speed changes over the approach: Linear is constant; EaseIn starts slowly; EaseOut finishes slowly; EaseInOut softens both ends. EasingStrength controls the non-linear presets."
LG_Tip_lightgun_station_EasingStrength<localizes> : message = "Exponent for the selected easing preset, clamped to 1..8. 1 is linear, 2 is the default gentle curve. Has no effect when RouteEasing is Linear."
LG_Tip_lightgun_station_SamplesPerSecond<localizes> : message = "Hidden-player follow updates per second during travel, clamped to 1..120. Default 30. Live cameras use native interpolated movement separately; this is not the camera frame rate."
LG_Tip_lightgun_station_ReloadOnArrival<localizes> : message = "Optional extra refill when travel into this station finishes. Cover entry is the normal reload mechanic, so leave this off unless the station should arrive with a full magazine regardless of cover state."
LG_Tip_lightgun_station_HideWaypointMarkersAtRuntime<localizes> : message = "Hide this station arrival-waypoint device markers during play. They still guide movement. This does not hide arbitrary props or change the path; leave false only when visually debugging authoring handles."
LG_Description_lightgun_start_station<localizes> : message = "The first combat stop and route itinerary. Assign its shooting/cover target cameras and encounters, then list later stops in CombatStations. START is already stop 0 and must not appear in its own list. This guide is informational only; changing its text does not affect gameplay."
LG_Tip_lightgun_start_station_CombatStations<localizes> : message = "Ordered list of later combat stations. START is automatically stop 0: never add START here or repeat a station. Empty gives a single-stop blank template. Duplicate each new station with its own cameras/encounter and reconnect references before adding it."
LG_Category_lightgun_route_Station<localizes> : message = "01 - Station Setup"
LG_Category_lightgun_route_StationProgress<localizes> : message = "03 - Progression"
LG_Category_lightgun_route_Views<localizes> : message = "02 - Camera Views"
LG_Category_lightgun_route_Travel<localizes> : message = "04 - Arrival Travel"
LG_Category_lightgun_route_Route<localizes> : message = "02 - Route and Progression"

# Designer-facing easing presets for combat-station travel.
lightgun_route_easing := enum:
    Linear
    EaseIn
    EaseOut
    EaseInOut

# A lightweight placeable path handle. Its transform supplies both the route
# position and the rig orientation at that point.
lightgun_route_waypoint := class(creative_device):
    # Informational only. This field is never read by gameplay code.
    @editable:
        ToolTip := LG_Description_lightgun_route_waypoint
        Categories := array{LG_GuideCategory_lightgun_route}
    WaypointGuide : string = "Hover for device setup help (informational only)"


# One placeable combat point. The device transform is the final standing-rig
# transform. ArrivalWaypoints are optional route handles, ordered from the
# previous station toward this station.
lightgun_station := class(creative_device):
    # Informational only. This field is never read by gameplay code.
    @editable:
        ToolTip := LG_Description_lightgun_station
        Categories := array{LG_GuideCategory_lightgun_route}
    StationGuide : string = "Hover for device setup help (informational only)"


    var RegisteredInRoute : logic = false

    @editable:
        ToolTip := LG_Tip_lightgun_station_StationName
        Categories := array{LG_Category_lightgun_route_Station}
    StationName : string = "Combat station"

    # Optional local progression sources. Only the CURRENT station may advance.
    # Configure the action on the Input Trigger; players bind its key in settings.
    @editable:
        ToolTip := LG_Tip_lightgun_station_AdvanceInput
        Categories := array{LG_Category_lightgun_route_StationProgress}
    AdvanceInput : ?input_trigger_device = false

    @editable:
        ToolTip := LG_Tip_lightgun_station_AdvanceTrigger
        Categories := array{LG_Category_lightgun_route_StationProgress}
    AdvanceTrigger : ?trigger_device = false

    @editable:
        ToolTip := LG_Tip_lightgun_station_Encounters
        Categories := array{LG_Category_lightgun_route_Station}
    Encounters : []lightgun_encounter = array{}

    # World-space height adjustment (cm) for the invisible player target only.
    # Use to clear railings/platform edges when enemies stand above the camera.
    # Does not move either camera, the station marker, or any NPC.
    @editable:
        ToolTip := LG_Tip_lightgun_station_PlayerTargetHeightOffset
        Categories := array{LG_Category_lightgun_route_Views}
    PlayerTargetHeightOffset : float = 0.0

    # Assign separate authoring cameras, never the game manager's live camera pair.
    @editable:
        ToolTip := LG_Tip_lightgun_station_StandingCameraTarget
        Categories := array{LG_Category_lightgun_route_Views}
    StandingCameraTarget : ?gameplay_camera_fixed_point_device = false

    @editable:
        ToolTip := LG_Tip_lightgun_station_DuckedCameraTarget
        Categories := array{LG_Category_lightgun_route_Views}
    DuckedCameraTarget : ?gameplay_camera_fixed_point_device = false

    # All encounters must have explicit positive ExpectedEliminations to complete.
    @editable:
        ToolTip := LG_Tip_lightgun_station_AdvanceWhenEncountersComplete
        Categories := array{LG_Category_lightgun_route_StationProgress}
    AdvanceWhenEncountersComplete : logic = false

    @editable:
        ToolTip := LG_Tip_lightgun_station_ArrivalWaypoints
        Categories := array{LG_Category_lightgun_route_Travel}
    ArrivalWaypoints : []lightgun_route_waypoint = array{}

    @editable:
        ToolTip := LG_Tip_lightgun_station_TravelDuration
        Categories := array{LG_Category_lightgun_route_Travel}
    TravelDuration : float = 2.0

    @editable:
        ToolTip := LG_Tip_lightgun_station_RouteEasing
        Categories := array{LG_Category_lightgun_route_Travel}
    RouteEasing : lightgun_route_easing = lightgun_route_easing.EaseInOut

    # Exponent used by the ease presets. 1.0 is linear; 2.0 is a useful default.
    @editable:
        ToolTip := LG_Tip_lightgun_station_EasingStrength
        Categories := array{LG_Category_lightgun_route_Travel}
    EasingStrength : float = 2.0

    # Hidden player-proxy follow updates per second during travel. The rig and
    # cameras use native interpolated movement independently of this cadence.
    @editable:
        ToolTip := LG_Tip_lightgun_station_SamplesPerSecond
        Categories := array{LG_Category_lightgun_route_Travel}
    SamplesPerSecond : float = 30.0

    @editable:
        ToolTip := LG_Tip_lightgun_station_ReloadOnArrival
        Categories := array{LG_Category_lightgun_route_StationProgress}
    ReloadOnArrival : logic = false

    # Marker props are authoring handles and are normally hidden in play.
    @editable:
        ToolTip := LG_Tip_lightgun_station_HideWaypointMarkersAtRuntime
        Categories := array{LG_Category_lightgun_route_Travel}
    HideWaypointMarkersAtRuntime : logic = true

    OnBegin<override>()<suspends>:void=
        if (HideWaypointMarkersAtRuntime?):
            for (Waypoint : ArrivalWaypoints):
                Waypoint.Hide()

    SafeTravelDuration() : float=
        if (TravelDuration < 0.05):
            return 0.05
        return TravelDuration

    SafeSamplesPerSecond() : float=
        if (SamplesPerSecond < 1.0):
            return 1.0
        if (SamplesPerSecond > 120.0):
            return 120.0
        return SamplesPerSecond

    SafeEasingStrength() : float=
        if (EasingStrength < 1.0):
            return 1.0
        if (EasingStrength > 8.0):
            return 8.0
        return EasingStrength

# Dedicated route entry device: inherits the same two views, local progression,
# and encounters as a combat station. Do not include this in CombatStations.
# Assign this once on the game manager; add/duplicate subsequent stations here.
lightgun_start_station := class(lightgun_station):
    # Informational only. This field is never read by gameplay code.
    @editable:
        ToolTip := LG_Description_lightgun_start_station
        Categories := array{LG_GuideCategory_lightgun_route}
    StartGuide : string = "Hover for device setup help (informational only)"


    @editable:
        ToolTip := LG_Tip_lightgun_start_station_CombatStations
        Categories := array{LG_Category_lightgun_route_Route}
    CombatStations : []lightgun_station = array{}

ApplyLightgunRouteEasing(
    RawAlpha : float,
    RouteEasing : lightgun_route_easing,
    StrengthInput : float
) : float=
    Alpha := Clamp(RawAlpha, 0.0, 1.0)
    var Strength : float = StrengthInput
    if (Strength < 1.0):
        set Strength = 1.0
    if (Strength > 8.0):
        set Strength = 8.0

    if (RouteEasing = lightgun_route_easing.Linear):
        return Alpha
    if (RouteEasing = lightgun_route_easing.EaseIn):
        return Pow(Alpha, Strength)
    if (RouteEasing = lightgun_route_easing.EaseOut):
        return 1.0 - Pow(1.0 - Alpha, Strength)

    # Symmetric ease-in-out with a designer-tunable exponent.
    if (Alpha < 0.5):
        return 0.5 * Pow(Alpha * 2.0, Strength)
    return 1.0 - (0.5 * Pow((1.0 - Alpha) * 2.0, Strength))
