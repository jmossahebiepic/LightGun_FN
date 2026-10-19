using { /Verse.org/Simulation }
using { /Verse.org/Input }
using { /Verse.org/SpatialMath }

# Virtual Pointer click handler is deliberately isolated so that `vector3` here
# unambiguously resolves to /Verse.org/SpatialMath (LUF) - the type that
# PointerSelect and DeprojectViewportToWorld use - separate from the
# /UnrealEngine.com/Temporary/SpatialMath (XYZ) vector3 used for world math in
# lightgun_controller.verse. Deproject here, then forward only float components;
# importing both vector types into one file can produce subtle compile failures.
lightgun_pointer_click_handler := class:
    Owner : lightgun_controller
    Player : player
    Agent : agent

    OnPointerSelect(Arg : tuple(player, vector3)) : void=
        ClickPos := Arg(1)
        Ray := Player.DeprojectViewportToWorld(ClickPos)
        Origin := Ray.Origin
        Direction := Ray.Direction
        Owner.OnPointerRay(
            Player,
            Agent,
            ClickPos.Left, ClickPos.Up,
            Origin.Left, Origin.Up, Origin.Forward,
            Direction.Left, Direction.Up, Direction.Forward
        )
