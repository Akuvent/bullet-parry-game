extends Node
## Global flow: hub ↔ levels, seamless door transitions, restart hooks.
## Prototype: tiny hub with two doors; instant restart on fail.

#region State
## Shared by every bullet - built once per level, never per spawn.
var astar_grid: AStarGrid2D
var world_tiles: TileMapLayer
#endregion


#region Pathfinding
## Build the pathfinding grid from the level's wall tiles. Call once, from the
## level's _ready.
func build_grid(tiles: TileMapLayer) -> void:
	world_tiles = tiles
	astar_grid = AStarGrid2D.new()
	# get_used_rect() only spans painted cells (the walls), not the open arena,
	# so entities outside this rect fall out of bounds and can't be pathed to.
	var grow_region: Rect2i = world_tiles.get_used_rect().grow(4)
	astar_grid.region = grow_region
	astar_grid.cell_size = Vector2(64, 64)
	# Half a cell, so path points land on cell centres instead of corners -
	# corners are shared with diagonal walls and break line-of-sight tests.
	astar_grid.offset = Vector2(32, 32)
	astar_grid.update()
	# Treats every painted cell as solid; tiles without a collision polygon
	# would become invisible walls here.
	for cell in world_tiles.get_used_cells():
		astar_grid.set_point_solid(cell, true)


func world_to_cell(global_pos: Vector2) -> Vector2i:
	var cell := world_tiles.local_to_map(world_tiles.to_local(global_pos))
	return cell
#endregion
