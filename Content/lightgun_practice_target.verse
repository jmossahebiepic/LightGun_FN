using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }

LG_GuideCategory_lightgun_practice_target<localizes> : message = "00 - Device Guide"

# Localised UEFN Details-panel help; no gameplay logic below is changed.
LG_Description_lightgun_practice_target<localizes> : message = "A neutral shootable prop for calibration and simple examples. Assign TargetProp, add this device to one encounter, and configure aim radius/hits to break. No enemy AI or custom imported artwork is required. This guide is informational only; changing its text does not affect gameplay."
LG_Tip_lightgun_practice_target_TargetProp<localizes> : message = "Required neutral creative prop to show/hide, such as a cube or cylinder. Use a unique prop for each target. Its pivot plus AimHeightOffset supplies the aim centre. The prop hides until encounter activation and when broken; no imported asset is required."
LG_Tip_lightgun_practice_target_HitsToBreak<localizes> : message = "Accepted lightgun hits required to break this practice prop; minimum 1. Independent of game-manager DamagePerShot. Breaking the prop counts as one encounter elimination. Resets only on a fresh round, not a route revisit."
LG_Tip_lightgun_practice_target_HitRadius<localizes> : message = "World-space aim tolerance in centimetres around this prop aim centre; minimum 1. Larger is easier. This is a point-radius test, not the visible mesh shape; walls do not block custom hits."
LG_Tip_lightgun_practice_target_AimHeightOffset<localizes> : message = "World-Z offset in centimetres from the prop pivot to the desired aim centre. Positive raises it. Use 0 for a centred pivot; adjust for meshes whose pivot is at the base. Does not move the prop."
LG_Category_lightgun_practice_target_Practice<localizes> : message = "01 - Practice Target"

# Assign a simple cube/cylinder prop. The prop's transform is the aim centre.
# Does not deal damage to native props or require a custom imported asset.
lightgun_practice_target := class(creative_device):
    # Informational only. This field is never read by gameplay code.
    @editable:
        ToolTip := LG_Description_lightgun_practice_target
        Categories := array{LG_GuideCategory_lightgun_practice_target}
    PracticeTargetGuide : string = "Hover for device setup help (informational only)"

    @editable:
        ToolTip := LG_Tip_lightgun_practice_target_TargetProp
        Categories := array{LG_Category_lightgun_practice_target_Practice}
    TargetProp : ?creative_prop = false
    @editable:
        ToolTip := LG_Tip_lightgun_practice_target_HitsToBreak
        Categories := array{LG_Category_lightgun_practice_target_Practice}
    HitsToBreak : int = 1
    @editable:
        ToolTip := LG_Tip_lightgun_practice_target_HitRadius
        Categories := array{LG_Category_lightgun_practice_target_Practice}
    HitRadius : float = 60.0
    @editable:
        ToolTip := LG_Tip_lightgun_practice_target_AimHeightOffset
        Categories := array{LG_Category_lightgun_practice_target_Practice}
    AimHeightOffset : float = 0.0

    var Encounter : ?lightgun_encounter = false
    var RemainingHits : int = 0
    var Alive : logic = false

    Initialize(Owner : lightgun_encounter) : void=
        if (Encounter?):
            Print("LightGunFN: practice target assigned more than once; fix encounter references.")
            if (Controller := Owner.Controller?):
                set Controller.SetupErrors += 1
            return
        set Encounter = option{Owner}
        if (Prop := TargetProp?, Prop.IsValid[]):
            Prop.Hide()
        else:
            Print("LightGunFN: practice target is missing its prop.")
            if (Controller := Owner.Controller?):
                set Controller.SetupErrors += 1

    Activate() : void=
        if (Prop := TargetProp?, Prop.IsValid[]):
            set RemainingHits = Max(HitsToBreak, 1)
            set Alive = true
            Prop.Show()

    IsAlive()<transacts> : logic=
        logic{Alive?, Prop := TargetProp?, Prop.IsValid[]}

    AimPosition()<transacts> : vector3=
        if (Prop := TargetProp?, Prop.IsValid[]):
            return Prop.GetTransform().Translation + vector3{Z := AimHeightOffset}
        return GetTransform().Translation

    Hit() : void=
        if (not Alive?):
            return
        set RemainingHits -= 1
        if (RemainingHits <= 0):
            set Alive = false
            if (Prop := TargetProp?, Prop.IsValid[]):
                Prop.Hide()
            if (Owner := Encounter?):
                Owner.OnPracticeEliminated()
