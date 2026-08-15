extends Node2D
## Boot / playable entry - prototype arena lives here for now.

#region Node refs
@onready var world_tiles: TileMapLayer = $WorldTiles
#endregion


#region Lifecycle
func _ready() -> void:
	Game.build_grid(world_tiles)
#endregion
