extends Node
## Global flow: hub ↔ levels, seamless door transitions, restart hooks.
## Prototype: tiny hub with two doors; instant restart on fail.
var astar_grid : AStarGrid2D
var world_tiles: TileMapLayer

func build_grid(tiles: TileMapLayer):
	world_tiles = tiles
	astar_grid = AStarGrid2D.new()
	var grow_region = world_tiles.get_used_rect().grow(4)
	astar_grid.region = grow_region
	astar_grid.cell_size = Vector2(64, 64)
	astar_grid.offset = Vector2(32, 32)
	astar_grid.update()
	for cell in world_tiles.get_used_cells():
		astar_grid.set_point_solid(cell, true)

func world_to_cell(global_pos: Vector2) -> Vector2i:
	var cell := world_tiles.local_to_map(world_tiles.to_local(global_pos))
	return cell
