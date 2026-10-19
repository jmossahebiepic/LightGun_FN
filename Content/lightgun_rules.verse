# Small, side-effect-free rules shared by gameplay and the regression fixture.
# Profiles belong to devices, never to positions in CombatStations.
lightgun_camera_profile := enum:
    ExplicitOnly
    InputBay
    RangeA
    RangeB

lightgun_guard_profile := enum:
    ExplicitOnly
    RangeA
    RangeB

LightgunHasEncounterSources(Guards : int, NPCs : int, Creatures : int, Placers : int, Practice : int)<computes> : logic=
    logic{Guards > 0 or NPCs > 0 or Creatures > 0 or Placers > 0 or Practice > 0}

LightgunShouldReloadOnCover(WasCovered : logic, IsCovered : logic, Enabled : logic)<computes> : logic=
    logic{Enabled? and not WasCovered? and IsCovered?}
