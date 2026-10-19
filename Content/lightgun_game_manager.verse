# Lightgun Game Manager - the creator-facing device for new placements.
# Inherits all settings, Guide help and tooltips from the compatibility base.
# Keep lightgun_controller defined so already-placed instances retain their
# original property declarations and references. Do not place both managers
# in the same map. Existing Outliner labels are not changed by a Verse rename.
lightgun_game_manager := class(lightgun_controller):
