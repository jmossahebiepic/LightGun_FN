# Compatibility implementation: retain this class for already-placed instances.
# Place lightgun_game_manager for new work. Do not rename either serialized class:
# UEFN stores the Verse class identity on every placed device.
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/AI }
using { /Fortnite.com/Game }
using { /Fortnite.com/Input/Character }
using { /Fortnite.com/Playspaces }
using { /Fortnite.com/UI }
using { /Verse.org/Input }
using { /Verse.org/Input/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Simulation/Tags }
using { /Verse.org/Verse }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }

LG_GuideCategory_lightgun_game_manager<localizes> : message = "00 - Device Guide"

# Localised UEFN Details-panel help; no gameplay logic below is changed.
LG_Description_lightgun_game_manager<localizes> : message = "Lightgun Game Manager: place exactly one in a single-player map. It owns pointer fire, Space/pedal cover-and-reload, ammo, score, lives, HUD, the two LIVE cameras and route progression. Assign START before testing. Assign the LIVE cameras explicitly, or preserve the supplied lg_live_* Verse tags. This guide field is informational only."
LG_Tip_lightgun_game_manager_StandingCamera<localizes> : message = "Preferred explicit reference to the LIVE shooting Fixed Point Camera. The manager moves this actor through the route. Set Add to Players on Start off and never reuse a station target camera. The supplied example can fall back to the unique lg_live_shoot_tag camera."
LG_Tip_lightgun_game_manager_CoverCamera<localizes> : message = "Preferred explicit reference to a separate LIVE cover Fixed Point Camera. Space or the pedal switches to this view and reloads on entry when ReloadOnCover is true. Set Add to Players on Start off and match the shooting-camera FOV. The supplied example can fall back to lg_live_cover_tag."
LG_Tip_lightgun_game_manager_StartStation<localizes> : message = "Required. Assign the single Lightgun Start Station. It supplies the first views and owns the ordered CombatStations list. Place only one game manager and one START for this single-player template."
LG_Tip_lightgun_game_manager_VictoryEndGame<localizes> : message = "Optional native End Game device activated when the final station completes. Configure the player-winning result and whether it ends the round or game. The supplied example can fall back to lg_victory_end_tag. Without either reference or tag, gameplay stops but the round must be ended manually."
LG_Tip_lightgun_game_manager_DefeatEndGame<localizes> : message = "Optional native End Game device activated for zero lives, timeout or native player death. Configure a losing result distinct from VictoryEndGame. The supplied example can fall back to lg_defeat_end_tag. Without either reference or tag, gameplay stops but the round must be ended manually."
LG_Tip_lightgun_game_manager_AdvanceInput<localizes> : message = "Optional route-wide Input Trigger: its press advances from any station. Enable it and bind its Creative Input Action in Fortnite settings. Do not also route the same input through AdvanceTrigger. Presses during travel are ignored."
LG_Tip_lightgun_game_manager_AdvanceTrigger<localizes> : message = "Optional route-wide Trigger. A button, timer or other device can trigger it to advance from any station. For station-specific control, use the station device instead. Do not wire one input to both advancement paths."
LG_Tip_lightgun_game_manager_LoopRoute<localizes> : message = "True returns from the last station to START. This does NOT reset encounters, targets, ammo, score, lives or the timer. Already-complete automatic encounters can keep advancing on a loop. False is recommended for the first example."
LG_Tip_lightgun_game_manager_EndOnLastAdvance<localizes> : message = "When the route cannot loop, an advance request from its final station completes the run and activates VictoryEndGame. False keeps the player at the final station. This also applies to START when there are no later stations."
LG_Tip_lightgun_game_manager_EnableOnboardingChecklist<localizes> : message = "Turns START into a safe input-test bay. The HUD asks for one valid shot, Space/pedal cover-and-reload, then Space/pedal stand. START must have no encounter while this is enabled."
LG_Tip_lightgun_game_manager_AutoAdvanceOnChecklist<localizes> : message = "After all three input checks pass, show TEST COMPLETE for ChecklistCompletionDelay seconds, then travel to the first CombatStation. Requires at least one CombatStation. Turn off to keep START as a manual test bay."
LG_Tip_lightgun_game_manager_ChecklistCompletionDelay<localizes> : message = "Seconds to display TEST COMPLETE before automatic travel. Clamped to at least 0.1 seconds. Repeated input cannot queue another move."
LG_Tip_lightgun_game_manager_DuckIsToggle<localizes> : message = "True: each Fortnite Jump press toggles cover; release does nothing. Space is the default keyboard input, and a pedal may be bound to the same action. False: hold Jump to cover and release to expose. This is not hold-to-expose mode."
LG_Tip_lightgun_game_manager_ReloadOnCover<localizes> : message = "When true, entering cover refills the magazine once and plays ReloadSound. Standing does not reload. This template has no separate manual reload input: Space or the pedal is the normal reload mechanic. ReloadOnArrival remains an optional station override."
LG_Tip_lightgun_game_manager_ShowHud<localizes> : message = "Show the ammo, score, lives, timer and status overlay. Turning it off hides presentation only: all gameplay rules still apply. The HUD does not capture pointer clicks or pedal input."
LG_Tip_lightgun_game_manager_ShowCalibrationGuide<localizes> : message = "With ShowHud enabled, adds guide marks at centre and near the screen edges. Use DebugPointer logs to calibrate pointer acceptance. This is not a Sinden tracking border and does not calibrate the gun driver. Turn off for normal play."
LG_Tip_lightgun_game_manager_MagazineSize<localizes> : message = "Rounds available after startup or entering cover. Values below 1 are treated as 1. Every valid exposed shot spends one round, even on a miss. HUD visibility does not change ammunition rules."
LG_Tip_lightgun_game_manager_StartingLives<localizes> : message = "Arcade lives at the beginning of a fresh round; minimum 1. Accepted damage removes one life, with a brief grace window. This does not replace native Fortnite health: native elimination also ends the run."
LG_Tip_lightgun_game_manager_MatchTimerSeconds<localizes> : message = "Seconds allowed for the run, starting when player setup finishes. 0 or a negative value means untimed practice. Positive timers continue during cover and travel; reaching zero activates the defeat flow."
LG_Tip_lightgun_game_manager_DamagePerShot<localizes> : message = "Native-character damage for an accepted lightgun hit. Negative values become 0. Practice props use HitsToBreak instead. Custom hits use a point-radius test, not a weapon projectile or mesh trace."
LG_Tip_lightgun_game_manager_PointsPerHit<localizes> : message = "Score change for each accepted hit, not just an elimination. A negative value subtracts points but total score cannot go below 0. Applies to native characters and practice targets."
LG_Tip_lightgun_game_manager_HitRadius<localizes> : message = "Native-target aim tolerance in world centimetres; minimum 1 cm. Tests distance from the ray to the character view location, not the full body mesh. Larger values are more forgiving. The closest accepted depth wins; walls do not block these custom hits."
LG_Tip_lightgun_game_manager_MaxRange<localizes> : message = "Maximum accepted target depth along the aim ray, in centimetres. Keep greater than MinTargetDistance. Applies to native and practice targets. This limits range only; it does not add world-geometry occlusion."
LG_Tip_lightgun_game_manager_MinTargetDistance<localizes> : message = "Minimum accepted depth along the shot ray in centimetres; negative values become 0. Use this to exclude targets too close to the camera. Keep below MaxRange."
LG_Tip_lightgun_game_manager_PointerScaleX<localizes> : message = "Horizontal raw-pointer to normalised-screen scale. X = raw Left * scale + offset. For guide marks at X=0.1 and 0.9, scale = 0.8 / (rawRight - rawLeft). Defaults are setup-specific. A zero scale is not useful calibration."
LG_Tip_lightgun_game_manager_PointerOffsetX<localizes> : message = "Horizontal normalisation offset used with PointerScaleX. For the left guide mark, offset = 0.1 - rawLeft * scale. These values determine valid on-screen acceptance; native deprojection supplies the aiming ray."
LG_Tip_lightgun_game_manager_PointerScaleY<localizes> : message = "Vertical raw-pointer to normalised-screen scale. Y = raw Up * scale + offset. For guide marks at Y=0.1 and 0.8, scale = 0.7 / (rawBottom - rawTop). Often negative because raw Up decreases down the screen."
LG_Tip_lightgun_game_manager_PointerOffsetY<localizes> : message = "Vertical normalisation offset used with PointerScaleY. For the top guide mark, offset = 0.1 - rawTop * scale. Recheck centre and edges after changing display mode, resolution or scaling."
LG_Tip_lightgun_game_manager_PointerEdgeDeadzone<localizes> : message = "Fraction rejected at each screen edge after normalisation. 0.005 rejects the outer 0.5 percent; values clamp to 0..0.1. Rejected clicks do not fire or spend ammo. This can reject edge-pinned tracking but cannot detect a disconnected gun."
LG_Tip_lightgun_game_manager_DebugPointer<localizes> : message = "Log raw pointer coordinates, normalised coordinates and ray length for calibration. Enable with ShowCalibrationGuide for test rounds, then disable to avoid per-click log noise. Covered/travelling shots return before this log."
LG_Tip_lightgun_game_manager_DebugRoute<localizes> : message = "Log camera-route moves, point counts and arrival information. Useful for station-order and waypoint debugging. Does not draw the path or check collision clearance."
LG_Tip_lightgun_game_manager_DebugSpawns<localizes> : message = "Log successful hidden-player placement and station arrival. Use this to inspect the pawn enemies actually aim at; it is separate from the rendered camera. Placement failures are reported even when this is off."
LG_Tip_lightgun_game_manager_GuardAttackRefreshSeconds<localizes> : message = "Seconds between forced-attack refreshes for activated native guard encounters; minimum 0.5 seconds. Helps recover lost aggression. It does not guarantee line of sight, change guard loadouts or provide custom NPC behaviour."
LG_Tip_lightgun_game_manager_RouteInvincibilitySeconds<localizes> : message = "Protection window in seconds measured from the START of a successful route move; minimum 0. Travel and cover can protect the player longer. This is not an extra full delay added after arrival."
LG_Tip_lightgun_game_manager_DamageGraceSeconds<localizes> : message = "Seconds of native invulnerability after an accepted damage callback; minimum 0.05. Prevents rapid follow-up damage from consuming several arcade lives. A lethal native hit can still end the run."
LG_Tip_lightgun_game_manager_PlayerPawnCombatTargetDistance<localizes> : message = "Distance in centimetres in front of the LIVE shooting camera for the hidden player pawn enemies target. The supplied example uses 900 cm. Author a clear enemy sight line to this point at every station; a clear rendered camera view does not prove guards can see the pawn."
LG_Tip_lightgun_game_manager_PlayerPawnCameraUpOffset<localizes> : message = "World-Z offset in centimetres added to the camera-based pawn anchor. Positive raises the hidden pawn; negative lowers it. Added to each station PlayerTargetHeightOffset. Does not move either camera."
LG_Tip_lightgun_game_manager_PlayerPawnForwardOffset<localizes> : message = "Additional hidden-pawn offset in centimetres along the shooting camera local forward axis, after the main combat-target distance. Use to clear obstructions without moving the view."
LG_Tip_lightgun_game_manager_PlayerPawnRightOffset<localizes> : message = "Additional hidden-pawn offset in centimetres along the shooting camera local right axis. Positive moves right. Does not move the live cameras or station markers."
LG_Tip_lightgun_game_manager_PlayerPawnUpOffset<localizes> : message = "Additional hidden-pawn offset in centimetres along the shooting camera local up axis. On a tilted camera this is not world Z; use PlayerPawnCameraUpOffset or station PlayerTargetHeightOffset for world-height changes."
LG_Tip_lightgun_game_manager_MakePlayerInvulnerable<localizes> : message = "Testing/accessibility override: keep the native player invulnerable even while exposed and ignore arcade damage feedback. Does not stop timeout or route completion. Leave false when testing normal enemy damage and lives."
LG_Tip_lightgun_game_manager_HidePlayerPawn<localizes> : message = "Hide the frozen native player body while keeping it available as an enemy target. Turn off temporarily to inspect proxy placement. This does not remove collision, change health or replace cover protection."
LG_Tip_lightgun_game_manager_FireSounds<localizes> : message = "Optional Audio Player pool used in round-robin order for successful shots. Leave empty for silence. Use non-spatial, non-attenuated player feedback and enough players for the intended rapid-fire cadence."
LG_Tip_lightgun_game_manager_HitSounds<localizes> : message = "Optional round-robin Audio Player pool for accepted native/practice target hits. This is hit confirmation, not elimination-only feedback. Configure player-local audio without distance attenuation. Empty means silence."
LG_Tip_lightgun_game_manager_ReloadSound<localizes> : message = "Optional Audio Player played when cover entry reloads the magazine or a station uses ReloadOnArrival. Reload requests are ignored during travel or after the run ends. Configure non-spatial, non-attenuated player feedback."
LG_Tip_lightgun_game_manager_EmptySound<localizes> : message = "Optional dry-fire Audio Player for valid exposed trigger presses with zero ammo. Limited to one play per 0.5 seconds. Covered, travelling and invalid-pointer attempts do not play it."
LG_Category_lightgun_controller_Setup<localizes> : message = "01 - Required Setup"
LG_Category_lightgun_controller_Route<localizes> : message = "02 - Route and Progression"
LG_Category_lightgun_controller_Controls<localizes> : message = "03 - Cover and Reload"
LG_Category_lightgun_controller_Hud<localizes> : message = "08 - HUD"
LG_Category_lightgun_controller_Rules<localizes> : message = "04 - Game Rules"
LG_Category_lightgun_controller_Aiming<localizes> : message = "05 - Aiming and Calibration"
LG_Category_lightgun_controller_Debug<localizes> : message = "09 - Diagnostics"
LG_Category_lightgun_controller_Proxy<localizes> : message = "06 - Hidden Player Target"
LG_Category_lightgun_controller_Audio<localizes> : message = "07 - Audio"

# Single-player lightgun starter. No imported UI art or account-qualified paths.
# Explicit references are preferred for reusable maps. The supplied example also
# supports fixed Verse-tag fallbacks for native cameras and End Game devices.
# Live cameras move; station target cameras only provide cached transforms.
lightgun_controller := class(creative_device):
    # Informational only. This field is never read by gameplay code.
    @editable:
        ToolTip := LG_Description_lightgun_game_manager
        Categories := array{LG_GuideCategory_lightgun_game_manager}
    GameManagerGuide : string = "Hover for device setup help (informational only)"

    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_StandingCamera
        Categories := array{LG_Category_lightgun_controller_Setup}
    StandingCamera : ?gameplay_camera_fixed_point_device = false
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_CoverCamera
        Categories := array{LG_Category_lightgun_controller_Setup}
    CoverCamera : ?gameplay_camera_fixed_point_device = false
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_StartStation
        Categories := array{LG_Category_lightgun_controller_Setup}
    StartStation : ?lightgun_start_station = false
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_VictoryEndGame
        Categories := array{LG_Category_lightgun_controller_Setup}
    VictoryEndGame : ?end_game_device = false
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_DefeatEndGame
        Categories := array{LG_Category_lightgun_controller_Setup}
    DefeatEndGame : ?end_game_device = false
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_AdvanceInput
        Categories := array{LG_Category_lightgun_controller_Route}
    AdvanceInput : ?input_trigger_device = false
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_AdvanceTrigger
        Categories := array{LG_Category_lightgun_controller_Route}
    AdvanceTrigger : ?trigger_device = false
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_LoopRoute
        Categories := array{LG_Category_lightgun_controller_Route}
    LoopRoute : logic = false
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_EndOnLastAdvance
        Categories := array{LG_Category_lightgun_controller_Route}
    EndOnLastAdvance : logic = true
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_EnableOnboardingChecklist
        Categories := array{LG_Category_lightgun_controller_Route}
    EnableOnboardingChecklist : logic = true
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_AutoAdvanceOnChecklist
        Categories := array{LG_Category_lightgun_controller_Route}
    AutoAdvanceOnChecklist : logic = true
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_ChecklistCompletionDelay
        Categories := array{LG_Category_lightgun_controller_Route}
    ChecklistCompletionDelay : float = 1.0
    # Press Fortnite Jump (Space by default, or a bound pedal) to control cover.
    # False changes this from toggle to hold-to-cover/release-to-stand.
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_DuckIsToggle
        Categories := array{LG_Category_lightgun_controller_Controls}
    DuckIsToggle : logic = true
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_ReloadOnCover
        Categories := array{LG_Category_lightgun_controller_Controls}
    ReloadOnCover : logic = true
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_ShowHud
        Categories := array{LG_Category_lightgun_controller_Hud}
    ShowHud : logic = true
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_ShowCalibrationGuide
        Categories := array{LG_Category_lightgun_controller_Hud}
    ShowCalibrationGuide : logic = false
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_MagazineSize
        Categories := array{LG_Category_lightgun_controller_Rules}
    MagazineSize : int = 6
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_StartingLives
        Categories := array{LG_Category_lightgun_controller_Rules}
    StartingLives : int = 3
    # Zero disables the timer for a blank sandbox.
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_MatchTimerSeconds
        Categories := array{LG_Category_lightgun_controller_Rules}
    MatchTimerSeconds : int = 0
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_DamagePerShot
        Categories := array{LG_Category_lightgun_controller_Rules}
    DamagePerShot : float = 25.0
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_PointsPerHit
        Categories := array{LG_Category_lightgun_controller_Rules}
    PointsPerHit : int = 100
    # Prototype point-radius targeting, NOT mesh/occlusion collision.
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_HitRadius
        Categories := array{LG_Category_lightgun_controller_Aiming}
    HitRadius : float = 50.0
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_MaxRange
        Categories := array{LG_Category_lightgun_controller_Aiming}
    MaxRange : float = 10000.0
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_MinTargetDistance
        Categories := array{LG_Category_lightgun_controller_Aiming}
    MinTargetDistance : float = 25.0
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_PointerScaleX
        Categories := array{LG_Category_lightgun_controller_Aiming}
    PointerScaleX : float = 0.0193
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_PointerOffsetX
        Categories := array{LG_Category_lightgun_controller_Aiming}
    PointerOffsetX : float = 0.0
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_PointerScaleY
        Categories := array{LG_Category_lightgun_controller_Aiming}
    PointerScaleY : float = -0.0334
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_PointerOffsetY
        Categories := array{LG_Category_lightgun_controller_Aiming}
    PointerOffsetY : float = 0.0
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_PointerEdgeDeadzone
        Categories := array{LG_Category_lightgun_controller_Aiming}
    PointerEdgeDeadzone : float = 0.005
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_DebugPointer
        Categories := array{LG_Category_lightgun_controller_Debug}
    DebugPointer : logic = false
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_DebugRoute
        Categories := array{LG_Category_lightgun_controller_Debug}
    DebugRoute : logic = false
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_DebugSpawns
        Categories := array{LG_Category_lightgun_controller_Debug}
    DebugSpawns : logic = false
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_GuardAttackRefreshSeconds
        Categories := array{LG_Category_lightgun_controller_Rules}
    GuardAttackRefreshSeconds : float = 2.0
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_RouteInvincibilitySeconds
        Categories := array{LG_Category_lightgun_controller_Rules}
    RouteInvincibilitySeconds : float = 1.0
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_DamageGraceSeconds
        Categories := array{LG_Category_lightgun_controller_Rules}
    DamageGraceSeconds : float = 0.75
    # Author a clear firing lane for this invisible target at every station.
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_PlayerPawnCombatTargetDistance
        Categories := array{LG_Category_lightgun_controller_Proxy}
    PlayerPawnCombatTargetDistance : float = 1200.0
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_PlayerPawnCameraUpOffset
        Categories := array{LG_Category_lightgun_controller_Proxy}
    PlayerPawnCameraUpOffset : float = -70.0
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_PlayerPawnForwardOffset
        Categories := array{LG_Category_lightgun_controller_Proxy}
    PlayerPawnForwardOffset : float = 0.0
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_PlayerPawnRightOffset
        Categories := array{LG_Category_lightgun_controller_Proxy}
    PlayerPawnRightOffset : float = 0.0
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_PlayerPawnUpOffset
        Categories := array{LG_Category_lightgun_controller_Proxy}
    PlayerPawnUpOffset : float = 0.0
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_MakePlayerInvulnerable
        Categories := array{LG_Category_lightgun_controller_Rules}
    MakePlayerInvulnerable : logic = false
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_HidePlayerPawn
        Categories := array{LG_Category_lightgun_controller_Proxy}
    HidePlayerPawn : logic = true
    # Use non-spatial/non-attenuated Audio Players for player feedback.
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_FireSounds
        Categories := array{LG_Category_lightgun_controller_Audio}
    FireSounds : []audio_player_device = array{}
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_HitSounds
        Categories := array{LG_Category_lightgun_controller_Audio}
    HitSounds : []audio_player_device = array{}
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_ReloadSound
        Categories := array{LG_Category_lightgun_controller_Audio}
    ReloadSound : ?audio_player_device = false
    @editable:
        ToolTip := LG_Tip_lightgun_game_manager_EmptySound
        Categories := array{LG_Category_lightgun_controller_Audio}
    EmptySound : ?audio_player_device = false

    var LockedCamera : gameplay_camera_fixed_point_device = gameplay_camera_fixed_point_device{}
    var DuckedCamera : gameplay_camera_fixed_point_device = gameplay_camera_fixed_point_device{}
    var SessionPlayer : ?player = false
    var SessionEnded : logic = false
    var Ready : logic = false
    var SetupErrors : int = 0
    var RoundEndEvent : event() = event(){}
    var Subscriptions : []cancelable = array{}
    var ConfiguredPlayerCharacters : [player]fort_character = map{}
    var SetupDonePlayers : [player]logic = map{}
    var IsDucking : [agent]logic = map{}
    var DesiredCover : [agent]logic = map{}
    var Ammo : [player]int = map{}
    var Scores : [player]int = map{}
    var Lives : [player]int = map{}
    var Huds : [player]lightgun_hud = map{}
    var RemainingTime : int = 0
    var NextDamageTime : float = 0.0
    var NextEmptySoundTime : float = 0.0
    var FireSoundIndex : int = 0
    var HitSoundIndex : int = 0
    var GuardAttackTarget : ?fort_character = false
    var NextGuardAttackRefreshTime : float = 0.0
    var IsTransitioning : logic = false
    var RouteGraceActive : logic = false
    var RouteGraceGeneration : int = 0
    var CurrentStationIndex : int = 0
    var RouteStations : []lightgun_station = array{}
    var ActiveEncounters : []lightgun_encounter = array{}
    var StationStandingTargets : [int]transform = map{}
    var StationDuckedTargets : [int]transform = map{}
    var LockedCameraRelativeTransform : ?transform = false
    var DuckedCameraRelativeToStanding : ?transform = false
    var ResolvedStandingCamera : ?gameplay_camera_fixed_point_device = false
    var ResolvedCoverCamera : ?gameplay_camera_fixed_point_device = false
    var ResolvedVictoryEndGame : ?end_game_device = false
    var ResolvedDefeatEndGame : ?end_game_device = false
    var ChecklistShot : logic = false
    var ChecklistCover : logic = false
    var ChecklistStand : logic = false
    var ChecklistComplete : logic = false
    var ChecklistAdvancePending : logic = false
    # Internal constants used by the preserved Hoth camera/proxy implementation.
    UsePlayerPawnProxy : logic = true
    PlayerPawnUsesStandingCamera : logic = true
    FreezePlayerPawn : logic = true
    DuckUsesJump : logic = true
    DuckPlayerPawnDownOffset : float = 0.0

    OnBegin<override>()<suspends>:void=
        # Resolution order is intentional: creator-authored editable references
        # win; fixed tags only support the supplied S00/S01/S02 example map.
        set ResolvedStandingCamera = StandingCamera
        set ResolvedCoverCamera = CoverCamera
        set ResolvedVictoryEndGame = VictoryEndGame
        set ResolvedDefeatEndGame = DefeatEndGame
        if (not ResolvedStandingCamera?):
            set ResolvedStandingCamera = FindLiveShootCamera()
        if (not ResolvedCoverCamera?):
            set ResolvedCoverCamera = FindLiveCoverCamera()
        if (not ResolvedVictoryEndGame?):
            set ResolvedVictoryEndGame = FindVictoryEndGame()
        if (not ResolvedDefeatEndGame?):
            set ResolvedDefeatEndGame = FindDefeatEndGame()
        if:
            Standing := ResolvedStandingCamera?
            Cover := ResolvedCoverCamera?
            Start := StartStation?
        then:
            set LockedCamera = Standing
            set DuckedCamera = Cover
            set RouteStations = array{Start} + Start.CombatStations
            ValidateStations()
            if (EnableOnboardingChecklist? and Start.Encounters.Length > 0):
                set SetupErrors += 1
                Print("LightGunFN: onboarding START must be safe; remove its encounters.")
            if (SetupErrors > 0):
                Print("LightGunFN: {SetupErrors} setup errors. Gameplay not started.")
                return
            CaptureRigCameraOffsets()
            CacheStationCameraTargets()
            InitializeStationDevices()
            if (SetupErrors > 0):
                Print("LightGunFN: invalid encounter/practice target assignments.")
                return
            TeleportRigToStation(Start)
            if (Input := AdvanceInput?):
                RememberSubscription(Input.PressedEvent.Subscribe(OnAdvanceInputPressed))
            if (Trigger := AdvanceTrigger?):
                RememberSubscription(Trigger.TriggeredEvent.Subscribe(OnAdvanceTriggered))
            set Ready = true
            RememberSubscription(GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerJoined))
            RememberSubscription(GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerLeft))
            for (Player : GetPlayspace().GetPlayers()):
                OnPlayerJoined(Player)
            spawn { MaintainSession() }
            Print("LightGunFN: configured. Single player; Jump=cover and reload.")
        else:
            Print("LightGunFN: assign START and distinct LIVE cameras, or restore the supplied lg_live_* tags.")

    RememberSubscription(Subscription : cancelable) : void=
        set Subscriptions += array{Subscription}

    # Native Creative devices cannot be serialized through the Verse-device MCP
    # property writer. VerseTagMarkupComponents keep the example reproducible
    # while explicit references remain available to creators in the Details panel.
    FindLiveShootCamera() : ?gameplay_camera_fixed_point_device=
        for (Object : FindCreativeObjectsWithTag(lg_live_shoot_tag)):
            if (Device := gameplay_camera_fixed_point_device[Object]):
                return option{Device}
        return false

    FindLiveCoverCamera() : ?gameplay_camera_fixed_point_device=
        for (Object : FindCreativeObjectsWithTag(lg_live_cover_tag)):
            if (Device := gameplay_camera_fixed_point_device[Object]):
                return option{Device}
        return false

    FindVictoryEndGame() : ?end_game_device=
        for (Object : FindCreativeObjectsWithTag(lg_victory_end_tag)):
            if (Device := end_game_device[Object]):
                return option{Device}
        return false

    FindDefeatEndGame() : ?end_game_device=
        for (Object : FindCreativeObjectsWithTag(lg_defeat_end_tag)):
            if (Device := end_game_device[Object]):
                return option{Device}
        return false

    FallbackStandingTarget(Index : int) : ?gameplay_camera_fixed_point_device=
        # These tags are tied to the three-stop example route. Additional
        # stations must assign their camera targets explicitly.
        if (Index = 0):
            for (Object : FindCreativeObjectsWithTag(lg_s00_shoot_tag)):
                if (Device := gameplay_camera_fixed_point_device[Object]):
                    return option{Device}
        if (Index = 1):
            for (Object : FindCreativeObjectsWithTag(lg_s01_shoot_tag)):
                if (Device := gameplay_camera_fixed_point_device[Object]):
                    return option{Device}
        if (Index = 2):
            for (Object : FindCreativeObjectsWithTag(lg_s02_shoot_tag)):
                if (Device := gameplay_camera_fixed_point_device[Object]):
                    return option{Device}
        return false

    FallbackCoverTarget(Index : int) : ?gameplay_camera_fixed_point_device=
        if (Index = 0):
            for (Object : FindCreativeObjectsWithTag(lg_s00_cover_tag)):
                if (Device := gameplay_camera_fixed_point_device[Object]):
                    return option{Device}
        if (Index = 1):
            for (Object : FindCreativeObjectsWithTag(lg_s01_cover_tag)):
                if (Device := gameplay_camera_fixed_point_device[Object]):
                    return option{Device}
        if (Index = 2):
            for (Object : FindCreativeObjectsWithTag(lg_s02_cover_tag)):
                if (Device := gameplay_camera_fixed_point_device[Object]):
                    return option{Device}
        return false

    ResolveStandingTarget(Index : int, Station : lightgun_station) : ?gameplay_camera_fixed_point_device=
        if (Target := Station.StandingCameraTarget?):
            return option{Target}
        return FallbackStandingTarget(Index)

    ResolveCoverTarget(Index : int, Station : lightgun_station) : ?gameplay_camera_fixed_point_device=
        if (Target := Station.DuckedCameraTarget?):
            return option{Target}
        return FallbackCoverTarget(Index)

    ValidateStations() : void=
        for (Index -> Station : RouteStations):
            if (Station.RegisteredInRoute?):
                set SetupErrors += 1
                Print("LightGunFN: station repeated in route: {Station.StationName}")
            set Station.RegisteredInRoute = true
            StandingOption := ResolveStandingTarget(Index, Station)
            CoverOption := ResolveCoverTarget(Index, Station)
            if:
                Standing := StandingOption?
                Cover := CoverOption?
            then:
                # Target cameras are transforms only, never player cameras.
                Print("LightGunFN station ready: {Station.StationName}")
            else:
                set SetupErrors += 1
                Print("LightGunFN: {Station.StationName} needs separate target cameras or its supplied station tags.")

    InitializeStationDevices() : void=
        for (Index -> Station : RouteStations):
            Handler := lightgun_station_advance_handler{Owner := Self, StationIndex := Index}
            if (Input := Station.AdvanceInput?):
                RememberSubscription(Input.PressedEvent.Subscribe(Handler.OnPressed))
            if (Trigger := Station.AdvanceTrigger?):
                RememberSubscription(Trigger.TriggeredEvent.Subscribe(Handler.OnTriggered))
            for (Encounter : Station.Encounters):
                Added := Encounter.Initialize(Self, Index)
                if (Added?):
                    set ActiveEncounters += array{Encounter}

    CacheStationCameraTargets() : void=
        for (Index -> Station : RouteStations):
            StandingOption := ResolveStandingTarget(Index, Station)
            if (Target := StandingOption?):
                if (set StationStandingTargets[Index] = Target.GetTransform()) {}
            CoverOption := ResolveCoverTarget(Index, Station)
            if (Target := CoverOption?):
                if (set StationDuckedTargets[Index] = Target.GetTransform()) {}

    ActivePlayers()<transacts> : []player=
        if (Player := SessionPlayer?):
            return array{Player}
        return array{}

    OnPlayerJoined(Player : player) : void=
        if (not Ready? or SessionEnded?):
            return
        if (Existing := SessionPlayer?, Existing <> Player):
            Print("LightGunFN supports one player. Set Island Settings Max Players to 1.")
            return
        set SessionPlayer = option{Player}
        spawn { RetryPlayerSetup(Player) }

    OnPlayerLeft(Player : player) : void=
        if (Current := SessionPlayer?, Current = Player):
            EndSession(Player, false, "Player left - restart round")
            if (Hud := Huds[Player]):
                Hud.Remove(Player)
            set SessionPlayer = false

    RetryPlayerSetup(Player : player)<suspends> : void=
        for (Attempt := 1..80):
            if (SessionEnded?):
                return
            if (Done := SetupDonePlayers[Player], Done?):
                return
            SetupPlayer(Player)
            Sleep(0.25)
        Print("LightGunFN: player input/character not ready after 20 seconds; restart round.")

    SetupPlayer(Player : player) : void=
        if (Done := SetupDonePlayers[Player], Done?):
            return
        if:
            Current := SessionPlayer?
            Current = Player
            Character := Player.GetFortCharacter[]
            Character.IsActive[]
            PlayerInput := GetPlayerInput[Player]
            GetPlayerUI[Player]
        then:
            Placed := ConfigurePlayerPawn(Player)
            if (not Placed?):
                return
            if (set SetupDonePlayers[Player] = true) {}
            if (set Ammo[Player] = Max(MagazineSize, 1)) {}
            if (set Scores[Player] = 0) {}
            if (set Lives[Player] = Max(StartingLives, 1)) {}
            if (set IsDucking[Player] = false) {}
            if (set DesiredCover[Player] = false) {}
            Hud := lightgun_hud{}
            if (ShowHud?):
                Hud.Add(Player, ShowCalibrationGuide)
            if (set Huds[Player] = Hud) {}
            set RemainingTime = Max(MatchTimerSeconds, 0)
            RefreshHud(Player)
            RefreshObjectiveHud(Player)
            RefreshPlayerCharacter(Player)
            PointerHandler := lightgun_pointer_click_handler{Owner := Self, Player := Player, Agent := Player}
            CoverHandler := lightgun_cover_input_handler{Owner := Self, Agent := Player}
            PlayerInput.AddInputMapping(TouchMapping)
            PlayerInput.AddInputMapping(TraversalMapping)
            RememberSubscription(PlayerInput.GetInputEvents(PointerSelect).BeginDetectEvent.Subscribe(PointerHandler.OnPointerSelect))
            RememberSubscription(PlayerInput.GetInputEvents(Jump).BeginDetectEvent.Subscribe(CoverHandler.OnPressed))
            RememberSubscription(PlayerInput.GetInputEvents(Jump).EndDetectEvent.Subscribe(CoverHandler.OnReleased))
            HideDefaultFortniteHud()
            if (Station := RouteStations[CurrentStationIndex]):
                ActivateStationEncounters(Station)
            if (RemainingTime > 0):
                spawn { RunMatchTimer(Player) }

    RefreshPlayerCharacter(Player : player) : void=
        if (SessionEnded?):
            return
        if (Character := Player.GetFortCharacter[], Character.IsActive[]):
            if (Previous := ConfiguredPlayerCharacters[Player], Previous = Character):
                return
            Placed := ConfigurePlayerPawn(Player)
            if (not Placed?):
                return
            if (set ConfiguredPlayerCharacters[Player] = Character) {}
            ApplyDesiredCover(Player)
            Handler := lightgun_damage_handler{Owner := Self, Player := Player, Character := Character}
            RememberSubscription(Character.DamagedEvent().Subscribe(Handler.OnDamaged))
            RememberSubscription(Character.EliminatedEvent().Subscribe(Handler.OnEliminated))
            set GuardAttackTarget = false

    MaintainSession()<suspends> : void=
        loop:
            Sleep(0.25)
            if (SessionEnded?):
                return
            for (Player : ActivePlayers()):
                if (Done := SetupDonePlayers[Player], Done?):
                    RefreshPlayerCharacter(Player)
                    SetDuckInvulnerability(Player, false)
                    OrderGuardsToAttack()
                    CheckStationCompletion()
                    RefreshObjectiveHud(Player)

    CheckStationCompletion() : void=
        if (IsTransitioning? or SessionEnded?):
            return
        if (Station := RouteStations[CurrentStationIndex], Station.AdvanceWhenEncountersComplete?):
            if (Station.Encounters.Length = 0):
                return
            for (Encounter : Station.Encounters):
                if (not Encounter.IsComplete()?):
                    return
            RequestRouteAdvance()

    RefreshObjectiveHud(Player : player) : void=
        if (Hud := Huds[Player]):
            if (EnableOnboardingChecklist? and CurrentStationIndex = 0):
                if (not ChecklistShot?):
                    Hud.SetObjective("TEST 1/3: FIRE")
                else if (not ChecklistCover?):
                    Hud.SetObjective("TEST 2/3: SPACE / PEDAL TO COVER + RELOAD")
                else if (not ChecklistStand?):
                    Hud.SetObjective("TEST 3/3: SPACE / PEDAL TO STAND")
                else:
                    Hud.SetObjective("TEST COMPLETE")
                return

            var Remaining : int = 0
            var HasAutomaticEncounter : logic = false
            if (Station := RouteStations[CurrentStationIndex]):
                for (Encounter : Station.Encounters):
                    if (Encounter.ExpectedEliminations > 0):
                        set HasAutomaticEncounter = true
                        set Remaining += Encounter.RemainingEliminations()
            if (HasAutomaticEncounter?):
                Hud.SetObjective("ENEMIES {Remaining}")
            else:
                Hud.SetObjective("PRACTICE")

    UpdateOnboardingChecklist(Player : player) : void=
        if (not EnableOnboardingChecklist? or CurrentStationIndex <> 0 or ChecklistComplete?):
            return
        RefreshObjectiveHud(Player)
        if (ChecklistShot? and ChecklistCover? and ChecklistStand?):
            set ChecklistComplete = true
            RefreshObjectiveHud(Player)
            if (AutoAdvanceOnChecklist? and RouteStations.Length > 1 and not ChecklistAdvancePending?):
                set ChecklistAdvancePending = true
                spawn { AdvanceAfterChecklistDelay() }

    AdvanceAfterChecklistDelay()<suspends> : void=
        Sleep(Max(ChecklistCompletionDelay, 0.1))
        if (not SessionEnded? and CurrentStationIndex = 0 and ChecklistComplete?):
            RequestRouteAdvance()

    OnGuardSpawned(Guard : agent) : void=
        OrderGuardsToAttack(?Force := true)

    OnGuardTargetLost(Result : device_ai_interaction_result) : void=
        set GuardAttackTarget = false

    OnGuardAwarenessLost(Guard : agent) : void=
        set GuardAttackTarget = false

    OrderGuardsToAttack(?Force : logic = false) : void=
        if (SessionEnded?):
            return
        if (Player := SessionPlayer?, Character := Player.GetFortCharacter[], Character.IsActive[]):
            Now := GetSimulationElapsedTime()
            if (not Force?, Old := GuardAttackTarget?, Old = Character, Now < NextGuardAttackRefreshTime):
                return
            set GuardAttackTarget = option{Character}
            set NextGuardAttackRefreshTime = Now + Max(GuardAttackRefreshSeconds, 0.5)
            for (Encounter : ActiveEncounters):
                Encounter.OrderGuardsToAttack(Player)

    RequestRouteAdvance() : void=
        if (SessionEnded? or not Ready? or IsTransitioning?):
            return
        if (Player := SessionPlayer?, Done := SetupDonePlayers[Player], Done?):
            var NextIndex : int = CurrentStationIndex + 1
            if (NextIndex >= RouteStations.Length):
                if (LoopRoute? and RouteStations.Length > 1):
                    set NextIndex = 0
                else:
                    if (EndOnLastAdvance?):
                        EndSession(Player, true, "Route complete")
                    return
            set IsTransitioning = true
            spawn { TravelToStation(NextIndex) }

    TravelToStation(StationIndex : int)<suspends> : void=
        if (SessionEnded?):
            return
        race:
            TravelRouteInternal(StationIndex)
            RoundEndEvent.Await()

    ShowAdvancingBanner(Player : player) : void=
        if (Hud := Huds[Player]):
            Hud.SetStatus("TRAVELLING")

    HideAdvancingBanner(Player : player) : void=
        if (Hud := Huds[Player]):
            Hud.SetStatus("READY")

    LogCombatPlayerState(Reason : string) : void=
        if (DebugSpawns?):
            Print("LightGunFN: {Reason}, station={CurrentStationIndex}")

    HideDefaultFortniteHud() : void=
        HiddenHud := array{
            player_hud_identifier_all{},
            creative_hud_identifier_all{},
            creative_hud_identifier_build_menu{},
            creative_hud_identifier_equipped_item{},
            creative_hud_identifier_health{},
            creative_hud_identifier_health_numbers{},
            creative_hud_identifier_hud_info{},
            creative_hud_identifier_interaction_prompts{},
            creative_hud_identifier_map_prompts{},
            creative_hud_identifier_minimap{},
            creative_hud_identifier_pickup_stream{},
            creative_hud_identifier_player_inventory{},
            creative_hud_identifier_round_info{},
            creative_hud_identifier_shields{},
            creative_hud_identifier_shield_numbers{},
            creative_hud_identifier_team_info{}
        }
        HUDController := GetPlayspace().GetHUDController()
        HUDController.HideElements(HiddenHud)
        for (Player : ActivePlayers()):
            HUDController.HideElementsForPlayer(Player, HiddenHud)

    ActivateStationEncounters(Station : lightgun_station) : void=
        for (Encounter : Station.Encounters):
            Encounter.Activate()

    RequestStationAdvance(StationIndex : int) : void=
        if (StationIndex = CurrentStationIndex):
            RequestRouteAdvance()

    StationStandingTransform(Index : int, Station : lightgun_station) : transform=
        if (Target := StationStandingTargets[Index]):
            return Target
        return StandingCameraTransformForRig(Station.GetTransform())

    StationDuckedTransform(Index : int, Station : lightgun_station) : transform=
        if (Target := StationDuckedTargets[Index]):
            return Target
        return DuckedCameraTransformForStanding(StationStandingTransform(Index, Station))

    TeleportRigToStation(Station : lightgun_station) : void=
        TeleportRigWithCameraTransforms(
            Station.GetTransform(),
            StationStandingTransform(0, Station),
            StationDuckedTransform(0, Station)
        )

    CaptureRigCameraOffsets() : void=
        RigTransform := GetTransform()
        StandingTransform := LockedCamera.GetTransform()
        CoverTransform := DuckedCamera.GetTransform()

        StandingLocalPosition :=
            RigTransform.Rotation.UnrotateVector(
                StandingTransform.Translation - RigTransform.Translation
            )
        StandingRelativeRotation :=
            StandingTransform.Rotation.UnrotateBy(RigTransform.Rotation)

        set LockedCameraRelativeTransform = option{transform:
            Translation := StandingLocalPosition
            Rotation := StandingRelativeRotation
            Scale := StandingTransform.Scale
        }

        DuckedFromStandingPosition :=
            StandingTransform.Rotation.UnrotateVector(
                CoverTransform.Translation - StandingTransform.Translation
            )
        DuckedFromStandingRotation :=
            CoverTransform.Rotation.UnrotateBy(StandingTransform.Rotation)
        set DuckedCameraRelativeToStanding = option{transform:
            Translation := DuckedFromStandingPosition
            Rotation := DuckedFromStandingRotation
            Scale := CoverTransform.Scale
        }

    OnAdvanceTriggered(MaybeAgent : ?agent) : void=
        RequestRouteAdvance()

    OnAdvanceInputPressed(Agent : agent) : void=
        RequestRouteAdvance()

    TravelRouteInternal(StationIndex : int)<suspends> : void=
        if (Station := RouteStations[StationIndex]):
            BeginRouteTravel()
            Points := BuildRoutePoints(Station)
            StartStandingCameraTransform := LockedCamera.GetTransform()
            StartDuckedCameraTransform := DuckedCamera.GetTransform()
            DestinationRigTransform := Station.GetTransform()
            DestinationStandingCameraTransform := StationStandingTransform(StationIndex, Station)
            DestinationDuckedCameraTransform := StationDuckedTransform(StationIndex, Station)
            StandingPoints := BuildCameraRoutePoints(Station, StartStandingCameraTransform, DestinationStandingCameraTransform, false)
            DuckedPoints := BuildCameraRoutePoints(Station, StartDuckedCameraTransform, DestinationDuckedCameraTransform, true)
            Duration := Station.SafeTravelDuration()
            SampleRate := Station.SafeSamplesPerSecond()
            TotalLength := RouteLength(Points)

            if (DebugRoute?):
                Print("Lightgun route moving to station {StationIndex}. Points={Points.Length}, Duration={Duration}")

            # Native MoveTo interpolates between updates instead of exposing
            # a succession of camera teleports. Short segments retain the
            # authored easing, without restarting movement every Verse tick.
            # Track simulation time so scheduling delays do not accumulate
            # once per sample and stretch the entire journey.
            race:
                block:
                    TravelStartedAt := GetSimulationElapsedTime()
                    loop:
                        Elapsed := GetSimulationElapsedTime() - TravelStartedAt
                        if (Elapsed >= Duration):
                            break
                        SegmentDuration := Min(0.1, Duration - Elapsed)
                        RawAlpha := Min((Elapsed + SegmentDuration) / Duration, 1.0)
                        EasedAlpha := ApplyLightgunRouteEasing(
                            RawAlpha,
                            Station.RouteEasing,
                            Station.SafeEasingStrength()
                        )
                        TargetTransform := RouteTransformAtDistance(
                            Points,
                            TotalLength * EasedAlpha,
                            TotalLength
                        )
                        StandingTransform := CameraRouteTransform(
                            Points, StandingPoints, EasedAlpha, TotalLength
                        )
                        DuckedTransform := CameraRouteTransform(
                            Points, DuckedPoints, EasedAlpha, TotalLength
                        )
                        MoveResults := sync:
                            Self.MoveTo(TargetTransform, SegmentDuration)
                            LockedCamera.MoveTo(StandingTransform, SegmentDuration)
                            DuckedCamera.MoveTo(DuckedTransform, SegmentDuration)
                        if:
                            MoveResults(0) <> move_to_result.DestinationReached or
                            MoveResults(1) <> move_to_result.DestinationReached or
                            MoveResults(2) <> move_to_result.DestinationReached
                        then:
                            # Avoid retrying a failed native move in a hot loop.
                            # Fall through to the exact endpoint recovery below.
                            Print("Lightgun route interpolation failed; recovering at station {StationIndex}.")
                            break
                block:
                    # The hidden pawn still follows for guard targeting, but
                    # its server updates no longer teleport the view cameras.
                    # race cancels this follower as soon as travel finishes.
                    loop:
                        Sleep(1.0 / SampleRate)
                        MovePlayersWithRig()

            # Always finish on the exact authored station transform.
            TeleportRigWithCameraTransforms(
                DestinationRigTransform,
                DestinationStandingCameraTransform,
                DestinationDuckedCameraTransform
            )
            set CurrentStationIndex = StationIndex
            FinishRouteTravel(Station)
        else:
            set IsTransitioning = false
            if (DebugRoute?):
                Print("Lightgun route station index {StationIndex} is invalid.")

    BeginRouteTravel() : void=
        set RouteGraceGeneration = RouteGraceGeneration + 1
        Generation := RouteGraceGeneration
        GraceSeconds := Max(RouteInvincibilitySeconds, 0.0)
        set RouteGraceActive = false
        if (GraceSeconds > 0.0):
            set RouteGraceActive = true
            spawn { EndRouteGraceAfterDelay(Generation, GraceSeconds) }
        for (Player : ActivePlayers()):
            if (Agent := agent[Player]):
                # Keep an already-active standing camera on the stack.
                # Removing/re-adding it can restart a native camera blend.
                if (Ducking := IsDucking[Agent], Ducking?):
                    StopDucking(Agent)
                SetDuckInvulnerability(Agent, true)
                ShowAdvancingBanner(Player)

    EndRouteGraceAfterDelay(Generation : int, GraceSeconds : float)<suspends> : void=
        Sleep(GraceSeconds)
        # A previous R transition must not end a newer transition's protection.
        if (Generation <> RouteGraceGeneration):
            return
        set RouteGraceActive = false
        for (Player : ActivePlayers()):
            if (Agent := agent[Player]):
                # Re-evaluate current cover, travel and permanent protection.
                SetDuckInvulnerability(Agent, false)

    FinishRouteTravel(Station : lightgun_station) : void=
        ActivateStationEncounters(Station)
        set IsTransitioning = false
        for (Player : ActivePlayers()):
            HideAdvancingBanner(Player)
            RefreshObjectiveHud(Player)
            if (Agent := agent[Player]):
                MovePlayerPawnForDuck(Agent, false)
                ApplyDesiredCover(Agent)
                if (Station.ReloadOnArrival?):
                    ReloadAmmo(Player)
        # The same player now occupies a different firing lane. Do not wait
        # for native perception to reacquire the hidden pawn at the new station.
        OrderGuardsToAttack(?Force := true)
        LogCombatPlayerState("station arrival")
        if (DebugRoute?):
            Print("Lightgun route arrived at station {CurrentStationIndex}.")

    BuildRoutePoints(Station : lightgun_station) : []transform=
        var Points : []transform = array{GetTransform()}
        for (Waypoint : Station.ArrivalWaypoints):
            set Points += array{Waypoint.GetTransform()}
        set Points += array{Station.GetTransform()}
        return Points

    BuildCameraRoutePoints(
        Station : lightgun_station,
        StartView : transform,
        EndView : transform,
        IsCover : logic
    ) : []transform=
        var Points : []transform = array{StartView}
        for (Waypoint : Station.ArrivalWaypoints):
            # Nulls describe the rig's position/orientation; use the same
            # calibrated view offsets as the rig, not a straight endpoint blend.
            var View : transform = StandingCameraTransformForRig(Waypoint.GetTransform())
            if (IsCover?):
                set View = DuckedCameraTransformForStanding(View)
            set Points += array{View}
        set Points += array{EndView}
        return Points

    CameraRouteTransform(
        RigPoints : []transform,
        CameraPoints : []transform,
        Alpha : float,
        TotalLength : float
    ) : transform=
        # Sample camera and rig using identical segment indices/alphas. Separate
        # camera arc lengths would let the view and the hidden pawn drift apart.
        if (First := CameraPoints[0], Last := CameraPoints[CameraPoints.Length - 1]):
            if (TotalLength <= 0.001):
                return InterpolateRouteTransform(First, Last, Alpha)
            ViewDistance := Clamp(Alpha, 0.0, 1.0) * TotalLength
            var Traversed : float = 0.0
            for (Index := 0..RigPoints.Length - 2):
                if:
                    RigStart := RigPoints[Index]
                    RigEnd := RigPoints[Index + 1]
                    ViewStart := CameraPoints[Index]
                    ViewEnd := CameraPoints[Index + 1]
                then:
                    SegmentLength := (RigEnd.Translation - RigStart.Translation).Length()
                    if (ViewDistance <= Traversed + SegmentLength, SegmentLength > 0.001):
                        return InterpolateRouteTransform(ViewStart, ViewEnd, (ViewDistance - Traversed) / SegmentLength)
                    set Traversed = Traversed + SegmentLength
            return Last
        return GetTransform()

    RouteLength(Points : []transform) : float=
        var Total : float = 0.0
        if (Points.Length >= 2):
            for (Index := 0..Points.Length - 2):
                if:
                    StartPoint := Points[Index]
                    EndPoint := Points[Index + 1]
                then:
                    set Total = Total +
                        (EndPoint.Translation - StartPoint.Translation).Length()
        return Total

    RouteTransformAtDistance(
        Points : []transform,
        DistanceInput : float,
        TotalLength : float
    ) : transform=
        var Result : transform = GetTransform()
        if (LastPoint := Points[Points.Length - 1]):
            set Result = LastPoint
        if (Points.Length < 2 or TotalLength <= 0.001):
            return Result

        TargetDistance := Clamp(DistanceInput, 0.0, TotalLength)
        var Traversed : float = 0.0
        var Found : logic = false

        for (Index := 0..Points.Length - 2):
            if:
                not Found?
                StartPoint := Points[Index]
                EndPoint := Points[Index + 1]
            then:
                SegmentLength :=
                    (EndPoint.Translation - StartPoint.Translation).Length()
                SegmentEnd := Traversed + SegmentLength
                if (TargetDistance <= SegmentEnd or Index = Points.Length - 2):
                    var SegmentAlpha : float = 1.0
                    if (SegmentLength > 0.001):
                        set SegmentAlpha =
                            Clamp(
                                (TargetDistance - Traversed) / SegmentLength,
                                0.0,
                                1.0
                            )
                    Position :=
                        StartPoint.Translation +
                        ((EndPoint.Translation - StartPoint.Translation) * SegmentAlpha)
                    if (Rotation := Slerp[
                        StartPoint.Rotation,
                        EndPoint.Rotation,
                        SegmentAlpha
                    ]):
                        set Result = transform:
                            Translation := Position
                            Rotation := Rotation
                            Scale := StartPoint.Scale
                    set Found = true
                set Traversed = SegmentEnd
        return Result

    InterpolateRouteTransform(
        StartTransform : transform,
        EndTransform : transform,
        AlphaInput : float
    ) : transform=
        Alpha := Clamp(AlphaInput, 0.0, 1.0)
        var Result : transform = EndTransform
        if (BlendedRotation := Slerp[
            StartTransform.Rotation,
            EndTransform.Rotation,
            Alpha
        ]):
            set Result = transform:
                Translation :=
                    StartTransform.Translation +
                    ((EndTransform.Translation - StartTransform.Translation) * Alpha)
                Rotation := BlendedRotation
                Scale := StartTransform.Scale
        return Result

    StandingCameraTransformForRig(RigTransform : transform) : transform=
        var Result : transform = LockedCamera.GetTransform()
        if (StandingRelative := LockedCameraRelativeTransform?):
            set Result = transform:
                Translation :=
                    RigTransform.Translation +
                    RigTransform.Rotation.RotateVector(
                        StandingRelative.Translation
                    )
                Rotation :=
                    StandingRelative.Rotation.RotateBy(RigTransform.Rotation)
                Scale := StandingRelative.Scale
        return Result

    DuckedCameraTransformForStanding(
        StandingCameraTransform : transform
    ) : transform=
        var Result : transform = DuckedCamera.GetTransform()
        if (DuckedRelative := DuckedCameraRelativeToStanding?):
            set Result = transform:
                Translation :=
                    StandingCameraTransform.Translation +
                    StandingCameraTransform.Rotation.RotateVector(
                        DuckedRelative.Translation
                    )
                Rotation :=
                    DuckedRelative.Rotation.RotateBy(
                        StandingCameraTransform.Rotation
                    )
                Scale := DuckedRelative.Scale
        return Result

    TeleportRig(RigTransform : transform) : void=
        StandingTransform := StandingCameraTransformForRig(RigTransform)
        DuckedTransform := DuckedCameraTransformForStanding(StandingTransform)
        TeleportRigWithCameraTransforms(
            RigTransform,
            StandingTransform,
            DuckedTransform
        )

    TeleportRigWithStandingCamera(
        RigTransform : transform,
        StandingCameraTransform : transform
    ) : void=
        DuckedTransform :=
            DuckedCameraTransformForStanding(StandingCameraTransform)
        TeleportRigWithCameraTransforms(
            RigTransform,
            StandingCameraTransform,
            DuckedTransform
        )

    TeleportRigWithCameraTransforms(
        RigTransform : transform,
        StandingCameraTransform : transform,
        DuckedCameraTransform : transform
    ) : void=
        if (Self.TeleportTo[RigTransform]) {}
        if (LockedCamera.TeleportTo[StandingCameraTransform]) {}
        if (DuckedCamera.TeleportTo[DuckedCameraTransform]) {}
        MovePlayersWithRig()

    MovePlayersWithRig() : void=
        for (Player : ActivePlayers()):
            if (Agent := agent[Player]):
                MovePlayerPawnForDuck(Agent, false)
                SetDuckInvulnerability(Agent, true)

    PlayerPawnAnchorTransform() : transform=
        var StationHeightOffset : float = 0.0
        if (Station := RouteStations[CurrentStationIndex]):
            set StationHeightOffset = Station.PlayerTargetHeightOffset
        if (PlayerPawnUsesStandingCamera?):
            CameraTransform := LockedCamera.GetTransform()
            return transform:
                Translation := CameraTransform.Translation +
                    CameraTransform.Rotation.GetLocalForward() * PlayerPawnCombatTargetDistance +
                    vector3{Z := PlayerPawnCameraUpOffset + StationHeightOffset}
                Rotation := CameraTransform.Rotation
                Scale := CameraTransform.Scale
        Anchor := GetTransform()
        return transform:
            Translation := Anchor.Translation + vector3{Z := StationHeightOffset}
            Rotation := Anchor.Rotation
            Scale := Anchor.Scale

    ConfigurePlayerPawn(Agent : agent) : logic=
        if:
            UsePlayerPawnProxy?
            FortChar := Agent.GetFortCharacter[]
            FortChar.IsActive[]
        then:
            Transform := PlayerPawnAnchorTransform()
            ProxyPosition :=
                Transform.Translation +
                (Transform.Rotation.GetLocalForward() * PlayerPawnForwardOffset) +
                (Transform.Rotation.GetLocalRight() * PlayerPawnRightOffset) +
                (Transform.Rotation.GetLocalUp() * PlayerPawnUpOffset)

            if (FortChar.TeleportTo[ProxyPosition, Transform.Rotation]):
                if (DebugSpawns?):
                    Print("Guard target: player proxy placed at {ProxyPosition}.")
                if (HidePlayerPawn?):
                    FortChar.Hide()
                SetDuckInvulnerability(Agent, false)
                # Jump is repurposed as the cover action. Keep the
                # pawn in stasis whenever that input is enabled so it can never
                # perform a native jump, even if FreezePlayerPawn is turned off.
                if (FreezePlayerPawn? or DuckUsesJump?):
                    FortChar.PutInStasis(stasis_args{
                        AllowTurning := false,
                        AllowFalling := false,
                        AllowEmotes := false
                    })
                return true
            else:
                Print("Guard target ERROR: player proxy placement failed at {ProxyPosition}.")
        return false

    MovePlayerPawnForDuck(Agent : agent, Ducking : logic) : void=
        if:
            UsePlayerPawnProxy?
            FortChar := Agent.GetFortCharacter[]
            FortChar.IsActive[]
        then:
            Transform := PlayerPawnAnchorTransform()
            var UpOffset : float = PlayerPawnUpOffset
            if (Ducking?):
                set UpOffset = PlayerPawnUpOffset - DuckPlayerPawnDownOffset

            ProxyPosition :=
                Transform.Translation +
                (Transform.Rotation.GetLocalForward() * PlayerPawnForwardOffset) +
                (Transform.Rotation.GetLocalRight() * PlayerPawnRightOffset) +
                (Transform.Rotation.GetLocalUp() * UpOffset)

            if (FortChar.TeleportTo[ProxyPosition, Transform.Rotation]):
                if (HidePlayerPawn?):
                    FortChar.Hide()
                if (FreezePlayerPawn? or DuckUsesJump?):
                    FortChar.PutInStasis(stasis_args{
                        AllowTurning := false,
                        AllowFalling := false,
                        AllowEmotes := false
                    })

    OnDuckPressed(Agent : agent) : void=
        if (SessionEnded?):
            return
        var Cover : logic = true
        if (DuckIsToggle?, Current := DesiredCover[Agent], Current?):
            set Cover = false
        if (set DesiredCover[Agent] = Cover) {}
        if (EnableOnboardingChecklist? and CurrentStationIndex = 0, Player := player[Agent]):
            if (Cover?):
                set ChecklistCover = true
            else:
                set ChecklistStand = true
            UpdateOnboardingChecklist(Player)
        if (not IsTransitioning?):
            ApplyDesiredCover(Agent)

    OnDuckReleased(Agent : agent) : void=
        if (SessionEnded? or DuckIsToggle?):
            return
        # Record releases during travel; arrival reapplies the real desired state.
        if (set DesiredCover[Agent] = false) {}
        if (EnableOnboardingChecklist? and CurrentStationIndex = 0, Player := player[Agent]):
            set ChecklistStand = true
            UpdateOnboardingChecklist(Player)
        if (not IsTransitioning?):
            ApplyDesiredCover(Agent)

    ApplyDesiredCover(Agent : agent) : void=
        if (SessionEnded? or IsTransitioning?):
            return
        if (Wanted := DesiredCover[Agent], Wanted?):
            StartDucking(Agent)
        else:
            StopDucking(Agent)

    StartDucking(Agent : agent) : void=
        # Entering cover owns the normal reload path. There is deliberately no
        # separate reload-input subscription in this template.
        if (set IsDucking[Agent] = true) {}
        SetDuckInvulnerability(Agent, true)
        ApplyDuckedCamera(Agent)
        if (Player := player[Agent], Hud := Huds[Player]):
            Hud.SetStatus("IN COVER")
        if (ReloadOnCover?, Player := player[Agent]):
            ReloadAmmo(Player)

    StopDucking(Agent : agent) : void=
        if (set IsDucking[Agent] = false) {}
        SetDuckInvulnerability(Agent, false)
        ApplyStandingCamera(Agent)
        if (Player := player[Agent], Hud := Huds[Player]):
            Hud.SetStatus("READY")

    ApplyStandingCamera(Agent : agent) : void=
        DuckedCamera.RemoveFrom(Agent)
        LockedCamera.RemoveFrom(Agent)
        LockedCamera.AddTo(Agent)

    ApplyDuckedCamera(Agent : agent) : void=
        LockedCamera.RemoveFrom(Agent)
        DuckedCamera.RemoveFrom(Agent)
        DuckedCamera.AddTo(Agent)

    SetDuckInvulnerability(Agent : agent, Ducking : logic) : void=
        if (Character := Agent.GetFortCharacter[], Character.IsActive[]):
            if (SessionEnded? or Ducking? or MakePlayerInvulnerable? or IsTransitioning? or RouteGraceActive?):
                Character.SetVulnerability(false)
            else if (Covered := IsDucking[Agent], Covered?):
                Character.SetVulnerability(false)
            else if (GetSimulationElapsedTime() < NextDamageTime):
                Character.SetVulnerability(false)
            else:
                Character.SetVulnerability(true)

    HandlePlayerDamaged(Player : player, Character : fort_character) : void=
        if (SessionEnded? or IsTransitioning? or RouteGraceActive? or MakePlayerInvulnerable?):
            return
        if (Covered := IsDucking[Player], Covered?):
            return
        if (Current := ConfiguredPlayerCharacters[Player], Current = Character):
            Now := GetSimulationElapsedTime()
            if (Now < NextDamageTime):
                return
            set NextDamageTime = Now + Max(DamageGraceSeconds, 0.05)
            Character.SetVulnerability(false)
            if (Count := Lives[Player]):
                Left := Max(Count - 1, 0)
                if (set Lives[Player] = Left) {}
                RefreshHud(Player)
                if (Left <= 0):
                    EndSession(Player, false, "Out of lives")
                else if (Hud := Huds[Player]):
                    Hud.FlashDamage()

    OnNativeElimination(Player : player, Character : fort_character) : void=
        if (Current := ConfiguredPlayerCharacters[Player], Current = Character):
            EndSession(Player, false, "Player eliminated")

    EndSession(Player : player, Won : logic, Reason : string) : void=
        if (SessionEnded?):
            return
        set SessionEnded = true
        RoundEndEvent.Signal()
        if (Character := Player.GetFortCharacter[], Character.IsActive[]):
            Character.SetVulnerability(false)
        if (Hud := Huds[Player]):
            Hud.SetStatus(Reason)
            if (Won?):
                Hud.SetObjective("RANGE COMPLETE")
            else:
                Hud.SetObjective("TRY AGAIN")
        Print("LightGunFN ended: {Reason}. Restart with a fresh round.")
        var EndDevice : ?end_game_device = ResolvedDefeatEndGame
        if (Won?):
            set EndDevice = ResolvedVictoryEndGame
        if (Device := EndDevice?, Player.IsActive[]):
            Device.Activate(Player)
        else:
            Print("LightGunFN: no usable result EndGame device. End/restart the round manually.")

    RunMatchTimer(Player : player)<suspends> : void=
        loop:
            Sleep(1.0)
            if (SessionEnded?):
                return
            set RemainingTime = Max(RemainingTime - 1, 0)
            RefreshHud(Player)
            if (RemainingTime = 0):
                EndSession(Player, false, "Time expired")
                return

    RefreshHud(Player : player) : void=
        if (Hud := Huds[Player], Rounds := Ammo[Player], Score := Scores[Player], Life := Lives[Player]):
            Hud.Update(Rounds, Max(MagazineSize, 1), Score, Life, RemainingTime, logic{MatchTimerSeconds > 0})

    ReloadAmmo(Player : player) : void=
        # Called by cover entry and optional station ReloadOnArrival only.
        if (SessionEnded? or IsTransitioning?):
            return
        if (set Ammo[Player] = Max(MagazineSize, 1)) {}
        if (Sound := ReloadSound?):
            Sound.Play(Player)
        RefreshHud(Player)

    OnPointerRay(
        Player : player, Agent : agent,
        ScreenX : float, ScreenY : float,
        OriginLeft : float, OriginUp : float, OriginForward : float,
        DirLeft : float, DirUp : float, DirForward : float
    ) : void=
        if (SessionEnded? or IsTransitioning?):
            return
        if (Covered := IsDucking[Agent], Covered?):
            return
        Screen := vector2{X := ScreenX * PointerScaleX + PointerOffsetX, Y := ScreenY * PointerScaleY + PointerOffsetY}
        Edge := Clamp(PointerEdgeDeadzone, 0.0, 0.1)
        RayLengthSquared := DirLeft * DirLeft + DirUp * DirUp + DirForward * DirForward
        if (DebugPointer?):
            Print("Pointer raw=({ScreenX},{ScreenY}), normalized=({Screen.X},{Screen.Y}), length2={RayLengthSquared}")
        if:
            Screen.X > Edge
            Screen.X < 1.0 - Edge
            Screen.Y > Edge
            Screen.Y < 1.0 - Edge
            RayLengthSquared > 0.5
            RayLengthSquared < 1.5
            Rounds := Ammo[Player]
        then:
            if (Rounds <= 0):
                Now := GetSimulationElapsedTime()
                if (Now >= NextEmptySoundTime):
                    set NextEmptySoundTime = Now + 0.5
                    if (Sound := EmptySound?):
                        Sound.Play(Agent)
                return
            if (EnableOnboardingChecklist? and CurrentStationIndex = 0):
                set ChecklistShot = true
                UpdateOnboardingChecklist(Player)
            # Charge before dealing damage; native elimination callbacks may advance/end.
            if (set Ammo[Player] = Rounds - 1) {}
            RefreshHud(Player)
            PlayFireSound(Agent)
            CameraOrigin := vector3{X := OriginForward, Y := -OriginLeft, Z := OriginUp}
            Direction := vector3{X := DirForward, Y := -DirLeft, Z := DirUp}
            FireAtBestTarget(Player, CameraOrigin, Direction)

    FireAtBestTarget(Player : player, Origin : vector3, Direction : vector3) : void=
        var BestCharacter : ?fort_character = false
        var BestPractice : ?lightgun_practice_target = false
        var BestDepth : float = Max(MaxRange, MinTargetDistance)
        # Only the current station's activated encounter targets can be hit.
        # Nearest depth wins among accepted point-radius candidates.
        # Deliberately no claim of world-geometry occlusion or mesh hit accuracy.
        if (Station := RouteStations[CurrentStationIndex]):
            for (Encounter : Station.Encounters):
                if (Encounter.Activated?):
                    for (Target : Encounter.Targets):
                        if (Target <> Player, Character := Target.GetFortCharacter[], Character.IsActive[]):
                            Offset := Character.GetViewLocation() - Origin
                            Depth := DotProduct(Offset, Direction)
                            Perpendicular := (Offset - Direction * Depth).Length()
                            if (Depth >= Max(MinTargetDistance, 0.0), Depth <= BestDepth, Perpendicular <= Max(HitRadius, 1.0)):
                                set BestDepth = Depth
                                set BestCharacter = option{Character}
                                set BestPractice = false
                    for (Target : Encounter.PracticeTargets):
                        if (Target.IsAlive()?):
                            Offset := Target.AimPosition() - Origin
                            Depth := DotProduct(Offset, Direction)
                            Perpendicular := (Offset - Direction * Depth).Length()
                            if (Depth >= Max(MinTargetDistance, 0.0), Depth <= BestDepth, Perpendicular <= Max(Target.HitRadius, 1.0)):
                                set BestDepth = Depth
                                set BestPractice = option{Target}
                                set BestCharacter = false
        if (Character := BestCharacter?):
            Character.Damage(Max(DamagePerShot, 0.0))
            ConfirmHit(Player)
        else if (Target := BestPractice?):
            Target.Hit()
            ConfirmHit(Player)

    ConfirmHit(Player : player) : void=
        if (Score := Scores[Player]):
            if (set Scores[Player] = Max(Score + PointsPerHit, 0)) {}
        RefreshHud(Player)
        PlayHitSound(Player)
        if (Hud := Huds[Player]):
            Hud.FlashHit()

    PlayFireSound(Agent : agent) : void=
        if (Sound := FireSounds[FireSoundIndex]):
            Sound.Play(Agent)
        set FireSoundIndex += 1
        if (FireSoundIndex >= FireSounds.Length):
            set FireSoundIndex = 0

    PlayHitSound(Agent : agent) : void=
        if (Sound := HitSounds[HitSoundIndex]):
            Sound.Play(Agent)
        set HitSoundIndex += 1
        if (HitSoundIndex >= HitSounds.Length):
            set HitSoundIndex = 0

    OnEnd<override>():void=
        set SessionEnded = true
        RoundEndEvent.Signal()
        for (Subscription : Subscriptions):
            Subscription.Cancel()
        for (Encounter : ActiveEncounters):
            Encounter.Cleanup()
        for (Player : ActivePlayers()):
            if (Hud := Huds[Player]):
                Hud.Remove(Player)
            if (Input := GetPlayerInput[Player]):
                Input.RemoveInputMapping(TouchMapping)
                Input.RemoveInputMapping(TraversalMapping)
            LockedCamera.RemoveFrom(Player)
            DuckedCamera.RemoveFrom(Player)
            if (Character := Player.GetFortCharacter[], Character.IsActive[]):
                Character.ReleaseFromStasis()
                Character.Show()
                Character.SetVulnerability(true)

lightgun_cover_input_handler := class:
    Owner : lightgun_controller
    Agent : agent
    OnPressed(Data : tuple(player, logic)) : void=
        Owner.OnDuckPressed(Agent)
    OnReleased(Data : tuple(player, float)) : void=
        Owner.OnDuckReleased(Agent)

lightgun_station_advance_handler := class:
    Owner : lightgun_controller
    StationIndex : int
    OnPressed(Agent : agent) : void=
        Owner.RequestStationAdvance(StationIndex)
    OnTriggered(Agent : ?agent) : void=
        Owner.RequestStationAdvance(StationIndex)

lightgun_damage_handler := class:
    Owner : lightgun_controller
    Player : player
    Character : fort_character
    OnDamaged(Result : damage_result) : void=
        Owner.HandlePlayerDamaged(Player, Character)
    OnEliminated(Result : elimination_result) : void=
        Owner.OnNativeElimination(Player, Character)
