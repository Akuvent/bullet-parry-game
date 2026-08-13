extends Node2D
## Boot / playable entry — prototype arena lives here for now.
@onready var world_tiles := $WorldTiles


func _ready():
	Game.build_grid(world_tiles)
func _physics_process(delta):
	if Input.is_action_just_pressed("grapple"):
		print("actual tiles", world_tiles.get_used_cells().size())
		print()
