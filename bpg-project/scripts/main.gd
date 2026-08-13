extends Node2D
## Boot / playable entry — prototype arena lives here for now.
@onready var world_tiles := $WorldTiles

## Debug: "grapple" toggles an overlay of the cells the pathfinding grid believes are walls.
var show_grid_debug := false


func _ready():
	Game.build_grid(world_tiles)


func _physics_process(_delta):
	if Input.is_action_just_pressed("grapple"):
		show_grid_debug = not show_grid_debug
		print("used cells: ", world_tiles.get_used_cells().size(),
			" | region: ", Game.astar_grid.region if Game.astar_grid else "no grid")
		queue_redraw()


func _draw() -> void:
	if not show_grid_debug or Game.astar_grid == null:
		return
	var grid := Game.astar_grid
	var cell: Vector2 = grid.cell_size

	# Region bounds. If this box isn't sitting over the level, the region is wrong.
	draw_rect(Rect2(Vector2(grid.region.position) * cell, Vector2(grid.region.size) * cell),
		Color(0, 1, 1, 0.8), false, 4.0)

	for point in grid.get_point_data_in_region(grid.region):
		if point["solid"]:
			draw_rect(Rect2(point["position"] - grid.offset, cell), Color(1, 0, 0, 0.35), true)
