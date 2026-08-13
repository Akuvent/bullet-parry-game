extends Node
## Global flow: hub ↔ levels, seamless door transitions, restart hooks.
## Prototype: tiny hub with two doors; instant restart on fail.
var astar_grid : AStarGrid2D

func build_grid(world_tiles):
	astar_grid = AStarGrid2D.new()
	var grow_region = Rect2i(4, 4, 8, 8).grow(4)
	astar_grid.region = grow_region
	astar_grid.cell_size = Vector2(64, 64)
	astar_grid.offset = Vector2(32, 32)
	astar_grid.update()
	for cell in world_tiles.get_used_cells():
		astar_grid.set_point_solid(cell, true)
