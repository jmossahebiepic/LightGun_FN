using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /Verse.org/Simulation/Tags }
using { /Verse.org/Verse }

LG_GuideCategory_lightgun_encounter<localizes> : message = "00 - Device Guide"

# Localised UEFN Details-panel help; no gameplay logic below is changed.
LG_Description_lightgun_encounter<localizes> : message = "Reusable targets for one station. The encounter activates once on first arrival and never respawns merely because the route revisits it. Set ExpectedEliminations to the complete authored wave before enabling automatic progression. This guide field is informational only."
LG_Tip_lightgun_encounter_GuardSpawners<localizes> : message = "Preferred explicit Guard Spawners for this encounter. List each spawner once and in no other encounter. Configure finite limits, enemy team, health and weapons on the native devices. The supplied S01/S02 examples can fall back to their lg_s0*_guard_tag devices when this array is empty."
LG_Tip_lightgun_encounter_NPCSpawners<localizes> : message = "Native NPC Spawners whose characters should be tracked for lightgun hits. Configure NPC definitions/behaviour on the native devices. Unlike Guard Spawners, custom NPCs do not receive automatic forced-attack orders. Do not share spawners between encounters."
LG_Tip_lightgun_encounter_CreatureSpawners<localizes> : message = "Native Creature Spawners for tracked enemy targets. Arrival activation enables their native wave spawning. Set native game-start spawning off for arrival-only waves and configure finite limits if using ExpectedEliminations."
LG_Tip_lightgun_encounter_CreaturePlacers<localizes> : message = "Native Creature Placers to spawn and track on first arrival. List each once and only in this encounter. Configure creature settings on the placer and include its expected eliminations in automatic wave completion."
LG_Tip_lightgun_encounter_PracticeTargets<localizes> : message = "Lightgun Practice Target devices for neutral prop shooting. Assign a different prop to each target and list each target once. Props appear on encounter activation and hide when broken; each broken target counts as one elimination, regardless of HitsToBreak."
LG_Tip_lightgun_encounter_SpawnOnFirstArrival<localizes> : message = "True enables native spawners and requests guard/NPC/placer spawns on first arrival. Disable native Enabled at Game Start for arrival-only spawning. False leaves native spawning to your other devices; practice props still activate on arrival. Revisits never respawn the wave."
LG_Tip_lightgun_encounter_ExpectedEliminations<localizes> : message = "Full-wave elimination count: native enemies plus practice targets. Include delayed spawns. A value of 0 or less disables automatic completion for this encounter. The station must also enable AdvanceWhenEncountersComplete."
LG_Category_lightgun_encounter_Targets<localizes> : message = "01 - Targets and Spawners"
LG_Category_lightgun_encounter_Waves<localizes> : message = "02 - Wave Activation"

# A native spawner belongs to exactly one encounter. Shared encounter references
# are initialized once and activate only on their first visited station.
lightgun_encounter := class(creative_device):
    # Informational only. This field is never read by gameplay code.
    @editable:
        ToolTip := LG_Description_lightgun_encounter
        Categories := array{LG_GuideCategory_lightgun_encounter}
    EncounterGuide : string = "Hover for device setup help (informational only)"

    @editable:
        ToolTip := LG_Tip_lightgun_encounter_GuardSpawners
        Categories := array{LG_Category_lightgun_encounter_Targets}
    GuardSpawners : []guard_spawner_device = array{}
    @editable:
        ToolTip := LG_Tip_lightgun_encounter_NPCSpawners
        Categories := array{LG_Category_lightgun_encounter_Targets}
    NPCSpawners : []npc_spawner_device = array{}
    @editable:
        ToolTip := LG_Tip_lightgun_encounter_CreatureSpawners
        Categories := array{LG_Category_lightgun_encounter_Targets}
    CreatureSpawners : []creature_spawner_device = array{}
    @editable:
        ToolTip := LG_Tip_lightgun_encounter_CreaturePlacers
        Categories := array{LG_Category_lightgun_encounter_Targets}
    CreaturePlacers : []creature_placer_device = array{}
    @editable:
        ToolTip := LG_Tip_lightgun_encounter_PracticeTargets
        Categories := array{LG_Category_lightgun_encounter_Targets}
    PracticeTargets : []lightgun_practice_target = array{}
    @editable:
        ToolTip := LG_Tip_lightgun_encounter_SpawnOnFirstArrival
        Categories := array{LG_Category_lightgun_encounter_Waves}
    SpawnOnFirstArrival : logic = true
    # Explicit full-wave count, including delayed enemies and practice props.
    # Zero = manual advancement. Never infer wave completion from alive==0.
    @editable:
        ToolTip := LG_Tip_lightgun_encounter_ExpectedEliminations
        Categories := array{LG_Category_lightgun_encounter_Waves}
    ExpectedEliminations : int = 0

    var Activated : logic = false
    var Initialized : logic = false
    var Controller : ?lightgun_controller = false
    var Targets : []agent = array{}
    var SeenCharacters : []fort_character = array{}
    var DeadCharacters : []fort_character = array{}
    var Eliminations : int = 0
    var Subscriptions : []cancelable = array{}
    var ResolvedGuardSpawners : []guard_spawner_device = array{}

    Subscribe(Subscription : cancelable) : void=
        set Subscriptions += array{Subscription}

    TaggedGuardSpawners(StationIndex : int) : []guard_spawner_device=
        # Template fallback only. A creator-added station should populate the
        # GuardSpawners editable rather than extending this index switch.
        var Result : []guard_spawner_device = array{}
        if (StationIndex = 1):
            for (Object : FindCreativeObjectsWithTag(lg_s01_guard_tag)):
                if (Spawner := guard_spawner_device[Object]):
                    set Result += array{Spawner}
        if (StationIndex = 2):
            for (Object : FindCreativeObjectsWithTag(lg_s02_guard_tag)):
                if (Spawner := guard_spawner_device[Object]):
                    set Result += array{Spawner}
        return Result

    Initialize(Owner : lightgun_controller, StationIndex : int) : logic=
        if (Initialized?):
            return false
        set Initialized = true
        set Controller = option{Owner}
        set ResolvedGuardSpawners = GuardSpawners
        # Explicit arrays take precedence; tags reproduce the supplied example
        # despite native-device references not being MCP-serializable.
        if (ResolvedGuardSpawners.Length = 0 and StationIndex > 0):
            set ResolvedGuardSpawners = TaggedGuardSpawners(StationIndex)
        if (ExpectedEliminations > 0 and ResolvedGuardSpawners.Length = 0 and PracticeTargets.Length = 0):
            Print("LightGunFN: encounter expects eliminations but has no tagged or assigned targets.")
            set Owner.SetupErrors += 1
        for (Spawner : ResolvedGuardSpawners):
            Subscribe(Spawner.SpawnedEvent.Subscribe(OnGuardSpawned))
            Subscribe(Spawner.TargetLostEvent.Subscribe(Owner.OnGuardTargetLost))
            Subscribe(Spawner.SuspiciousEvent.Subscribe(Owner.OnGuardAwarenessLost))
            Subscribe(Spawner.UnawareEvent.Subscribe(Owner.OnGuardAwarenessLost))
            for (Guard : Spawner.GetAgents()):
                OnGuardSpawned(Guard)
        for (Spawner : NPCSpawners):
            Subscribe(Spawner.SpawnedEvent.Subscribe(OnSpawned))
            for (NPC : Spawner.GetAgents()):
                OnSpawned(NPC)
        for (Spawner : CreatureSpawners):
            Subscribe(Spawner.SpawnedEvent.Subscribe(OnSpawned))
        for (Placer : CreaturePlacers):
            Subscribe(Placer.SpawnedEvent.Subscribe(OnSpawned))
        for (Target : PracticeTargets):
            Target.Initialize(Self)
        return true

    Activate() : void=
        if (Activated?):
            return
        set Activated = true
        for (Target : PracticeTargets):
            Target.Activate()
        if (SpawnOnFirstArrival?):
            for (Spawner : ResolvedGuardSpawners):
                Spawner.Enable()
                Spawner.Spawn()
            for (Spawner : NPCSpawners):
                Spawner.Enable()
                Spawner.Spawn()
            for (Spawner : CreatureSpawners):
                Spawner.Enable()
            for (Placer : CreaturePlacers):
                Placer.Spawn()
        if (Owner := Controller?):
            Owner.OrderGuardsToAttack(?Force := true)

    OnGuardSpawned(Guard : agent) : void=
        OnSpawned(Guard)
        if (Owner := Controller?):
            Owner.OnGuardSpawned(Guard)

    OnSpawned(Target : agent) : void=
        if (not Targets.Find[Target]):
            set Targets += array{Target}
        if (Character := Target.GetFortCharacter[], not SeenCharacters.Find[Character]):
            set SeenCharacters += array{Character}
            Handler := lightgun_encounter_elimination_handler{Owner := Self, Character := Character}
            Subscribe(Character.EliminatedEvent().Subscribe(Handler.OnEliminated))

    OnEliminated(Character : fort_character) : void=
        # Native callbacks can repeat during teardown; identity-based
        # deduplication prevents a false early route advance.
        if (DeadCharacters.Find[Character]):
            return
        set DeadCharacters += array{Character}
        set Eliminations += 1
        if (Owner := Controller?):
            Owner.OrderGuardsToAttack(?Force := true)

    OnPracticeEliminated() : void=
        set Eliminations += 1

    IsComplete()<transacts> : logic=
        logic{Activated?, ExpectedEliminations > 0, Eliminations >= ExpectedEliminations}

    RemainingEliminations()<transacts> : int=
        Max(ExpectedEliminations - Eliminations, 0)

    OrderGuardsToAttack(Target : agent) : void=
        if (Activated?):
            for (Spawner : ResolvedGuardSpawners):
                Spawner.ForceAttackTarget(Target, ?ForgetTime := 600.0, ?ForgetDistance := 100000.0)

    Cleanup() : void=
        for (Subscription : Subscriptions):
            Subscription.Cancel()

lightgun_encounter_elimination_handler := class:
    Owner : lightgun_encounter
    Character : fort_character
    OnEliminated(Result : elimination_result) : void=
        Owner.OnEliminated(Character)
