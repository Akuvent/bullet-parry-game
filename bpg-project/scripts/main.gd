extends Node2D
## Boot / playable entry — prototype arena lives here for now.

func _ready():
	Game.build_grid($WorldTiles)
