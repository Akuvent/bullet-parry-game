extends Node2D
## Boot / playable entry — prototype arena lives here for now.
@onready var world_tiles := $WorldTiles


func _ready():
	Game.build_grid(world_tiles)
