using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }

LightgunText<localizes>(Value : string) : message = "{Value}"

# Asset-free, non-interactive HUD: it reports state but never captures pointer,
# Space/pedal, or other gameplay input. Rules remain active when ShowHud is off.
lightgun_hud := class:
    var Root : ?canvas = false
    var FeedbackGeneration : int = 0
    AmmoText : text_block = text_block{DefaultTextColor := NamedColors.White, DefaultTextSize := 26.0}
    ScoreText : text_block = text_block{DefaultTextColor := NamedColors.White, DefaultTextSize := 22.0}
    LivesText : text_block = text_block{DefaultTextColor := NamedColors.White, DefaultTextSize := 22.0}
    TimerText : text_block = text_block{DefaultTextColor := NamedColors.White, DefaultTextSize := 22.0}
    StatusText : text_block = text_block{DefaultTextColor := NamedColors.White, DefaultTextSize := 26.0}
    FeedbackText : text_block = text_block{DefaultTextColor := NamedColors.White, DefaultTextSize := 22.0}
    ObjectiveText : text_block = text_block{DefaultTextColor := NamedColors.White, DefaultTextSize := 22.0}

    LabelSlot(Label : text_block, X : float, Y : float, AlignX : float) : canvas_slot=
        canvas_slot:
            Anchors := anchors{Minimum := vector2{X := X, Y := Y}, Maximum := vector2{X := X, Y := Y}}
            Alignment := vector2{X := AlignX, Y := 0.5}
            Offsets := margin{}
            SizeToContent := true
            Widget := Label

    BarSlot(Top : float, Bottom : float) : canvas_slot=
        canvas_slot:
            Anchors := anchors{Minimum := vector2{X := 0.0, Y := Top}, Maximum := vector2{X := 1.0, Y := Bottom}}
            Offsets := margin{}
            SizeToContent := false
            Widget := color_block{DefaultColor := NamedColors.Black, DefaultOpacity := 0.65}

    Add(Player : player, Calibration : logic) : void=
        Remove(Player)
        if (UI := GetPlayerUI[Player]):
            var Slots : []canvas_slot = array{
                BarSlot(0.0, 0.16),
                BarSlot(0.86, 1.0),
                LabelSlot(ScoreText, 0.04, 0.06, 0.0),
                LabelSlot(TimerText, 0.96, 0.06, 1.0),
                LabelSlot(LivesText, 0.04, 0.92, 0.0),
                LabelSlot(AmmoText, 0.96, 0.92, 1.0),
                LabelSlot(StatusText, 0.5, 0.92, 0.5),
                LabelSlot(FeedbackText, 0.5, 0.12, 0.5),
                LabelSlot(ObjectiveText, 0.5, 0.06, 0.5)
            }
            if (Calibration?):
                for (Point : array{
                    vector2{X := 0.5, Y := 0.5},
                    vector2{X := 0.1, Y := 0.1},
                    vector2{X := 0.9, Y := 0.1},
                    vector2{X := 0.1, Y := 0.8},
                    vector2{X := 0.9, Y := 0.8}
                }):
                    Cross := text_block:
                        DefaultText := LightgunText("+")
                        DefaultTextColor := NamedColors.White
                        DefaultTextSize := 32.0
                        DefaultShadowColor := NamedColors.Black
                        DefaultShadowOpacity := 1.0
                        DefaultShadowOffset := option{vector2{X := 1.0, Y := 1.0}}
                    set Slots += array{LabelSlot(Cross, Point.X, Point.Y, 0.5)}
            Widget := canvas{Slots := Slots}
            set Root = option{Widget}
            UI.AddWidget(Widget, player_ui_slot{InputMode := ui_input_mode.None, ZOrder := 105})
            SetStatus("READY")

    Update(Ammo : int, Capacity : int, Score : int, Lives : int, Seconds : int, Timed : logic) : void=
        AmmoText.SetText(LightgunText("AMMO {Ammo} / {Capacity}"))
        ScoreText.SetText(LightgunText("SCORE {Score}"))
        LivesText.SetText(LightgunText("LIVES {Lives}"))
        if (Timed?):
            TimerText.SetText(LightgunText("TIME {Seconds}"))
        else:
            TimerText.SetText(LightgunText("PRACTICE"))

    SetStatus(Value : string) : void=
        StatusText.SetText(LightgunText(Value))

    SetObjective(Value : string) : void=
        ObjectiveText.SetText(LightgunText(Value))

    FlashHit() : void=
        set FeedbackGeneration += 1
        FeedbackText.SetTextColor(NamedColors.White)
        FeedbackText.SetText(LightgunText("HIT"))
        spawn { ClearFeedback(FeedbackGeneration) }

    FlashDamage() : void=
        set FeedbackGeneration += 1
        FeedbackText.SetTextColor(NamedColors.Red)
        FeedbackText.SetText(LightgunText("DAMAGE"))
        spawn { ClearFeedback(FeedbackGeneration) }

    ClearFeedback(Generation : int)<suspends> : void=
        Sleep(0.3)
        if (Generation = FeedbackGeneration):
            FeedbackText.SetText(LightgunText(""))

    Remove(Player : player) : void=
        set FeedbackGeneration += 1
        if (UI := GetPlayerUI[Player], Widget := Root?):
            UI.RemoveWidget(Widget)
        set Root = false
