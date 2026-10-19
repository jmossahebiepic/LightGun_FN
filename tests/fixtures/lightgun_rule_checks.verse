using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }

# Test-only fixture: copy into Content temporarily, place once, run a fresh match.
lightgun_rule_checks := class(creative_device):
    var Passed : int = 0
    var Failed : int = 0

    Check(Name : string, Expected : logic, Actual : logic) : void=
        if ((Expected? and Actual?) or (not Expected? and not Actual?)):
            set Passed += 1
        else:
            set Failed += 1
            Print("LightGunFN TEST FAIL: {Name}")

    OnBegin<override>()<suspends>:void=
        Check("sources_0", false, LightgunHasEncounterSources(0, 0, 0, 0, 0))
        Check("sources_1", true, LightgunHasEncounterSources(1, 0, 0, 0, 0))
        Check("sources_2", true, LightgunHasEncounterSources(0, 1, 0, 0, 0))
        Check("sources_3", true, LightgunHasEncounterSources(1, 1, 0, 0, 0))
        Check("sources_4", true, LightgunHasEncounterSources(0, 0, 1, 0, 0))
        Check("sources_5", true, LightgunHasEncounterSources(1, 0, 1, 0, 0))
        Check("sources_6", true, LightgunHasEncounterSources(0, 1, 1, 0, 0))
        Check("sources_7", true, LightgunHasEncounterSources(1, 1, 1, 0, 0))
        Check("sources_8", true, LightgunHasEncounterSources(0, 0, 0, 1, 0))
        Check("sources_9", true, LightgunHasEncounterSources(1, 0, 0, 1, 0))
        Check("sources_10", true, LightgunHasEncounterSources(0, 1, 0, 1, 0))
        Check("sources_11", true, LightgunHasEncounterSources(1, 1, 0, 1, 0))
        Check("sources_12", true, LightgunHasEncounterSources(0, 0, 1, 1, 0))
        Check("sources_13", true, LightgunHasEncounterSources(1, 0, 1, 1, 0))
        Check("sources_14", true, LightgunHasEncounterSources(0, 1, 1, 1, 0))
        Check("sources_15", true, LightgunHasEncounterSources(1, 1, 1, 1, 0))
        Check("sources_16", true, LightgunHasEncounterSources(0, 0, 0, 0, 1))
        Check("sources_17", true, LightgunHasEncounterSources(1, 0, 0, 0, 1))
        Check("sources_18", true, LightgunHasEncounterSources(0, 1, 0, 0, 1))
        Check("sources_19", true, LightgunHasEncounterSources(1, 1, 0, 0, 1))
        Check("sources_20", true, LightgunHasEncounterSources(0, 0, 1, 0, 1))
        Check("sources_21", true, LightgunHasEncounterSources(1, 0, 1, 0, 1))
        Check("sources_22", true, LightgunHasEncounterSources(0, 1, 1, 0, 1))
        Check("sources_23", true, LightgunHasEncounterSources(1, 1, 1, 0, 1))
        Check("sources_24", true, LightgunHasEncounterSources(0, 0, 0, 1, 1))
        Check("sources_25", true, LightgunHasEncounterSources(1, 0, 0, 1, 1))
        Check("sources_26", true, LightgunHasEncounterSources(0, 1, 0, 1, 1))
        Check("sources_27", true, LightgunHasEncounterSources(1, 1, 0, 1, 1))
        Check("sources_28", true, LightgunHasEncounterSources(0, 0, 1, 1, 1))
        Check("sources_29", true, LightgunHasEncounterSources(1, 0, 1, 1, 1))
        Check("sources_30", true, LightgunHasEncounterSources(0, 1, 1, 1, 1))
        Check("sources_31", true, LightgunHasEncounterSources(1, 1, 1, 1, 1))
        Check("cover_0", false, LightgunShouldReloadOnCover(false, false, false))
        Check("cover_1", false, LightgunShouldReloadOnCover(true, false, false))
        Check("cover_2", false, LightgunShouldReloadOnCover(false, true, false))
        Check("cover_3", false, LightgunShouldReloadOnCover(true, true, false))
        Check("cover_4", false, LightgunShouldReloadOnCover(false, false, true))
        Check("cover_5", false, LightgunShouldReloadOnCover(true, false, true))
        Check("cover_6", true, LightgunShouldReloadOnCover(false, true, true))
        Check("cover_7", false, LightgunShouldReloadOnCover(true, true, true))
        Print("LightGunFN RULE TESTS: {Passed} passed, {Failed} failed")
