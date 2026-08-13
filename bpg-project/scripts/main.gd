extends Node2D
## Boot / playable entry — prototype arena lives here for now.
@onready var world_tiles := $WorldTiles


func _ready():
	Game.build_grid(world_tiles)
func _physics_process(delta):
	if Input.is_action_just_pressed("grapple"):
		print("actual tiles", world_tiles.get_used_cells().size())
		var grow_region = Rect2i(4, 4, 8, 8).grow(4)
		var a = Game.astar_grid.get_point_data_in_region(grow_region)
		draw_rect(a, Vector2(64, 64), Color(1, 0, 0, 0.35), true)
