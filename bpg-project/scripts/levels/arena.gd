extends Node2D
## Self-contained arena: clear / survive / exit + instant restart.


#region Node refs
@onready var world_tiles: TileMapLayer = get_node_or_null("WorldTiles")
#endregion


#region Lifecycle
func _ready() -> void:
	if world_tiles:
		Game.build_grid(world_tiles)
#endregion
