extends CharacterBody2D
## Homing bullet: outbound toward locked enemy, bounce on walls, return / await parry.

#region State machine
enum State { OUTBOUND, RETURN, AWAIT_PARRY, MISSED }
var state: State = State.OUTBOUND
#endregion

#region Config / refs
var speed: float = Heat.heat
var player: Node2D  # set in setup()
## Locked enemy while outbound.
var seek_target: Node2D
var targets := []
#endregion

#region Targeting scratch
## Reused by find_target(); best_distance starts at INF each search only if reset.
var best_distance: float = INF
var distance: float = INF
var parried: bool = false
#endregion

@export var parry_window_sec := 0.4
@export var turn_deg_per_sec := 270.0  # tune: lower = wider arcs
@onready var world_tiles: TileMapLayer = get_tree().current_scene.get_node("WorldTiles")

#region Lifecycle
func _ready() -> void:
	motion_mode = MOTION_MODE_FLOATING

func _physics_process(delta: float) -> void:
	speed = Heat.heat
	tracking(delta)
	print(State.keys()[state],': ',state)


func setup(p) -> void:
	player = p
	find_target()
	# One-shot launch; OUTBOUND steering takes over after this.
	if is_instance_valid(seek_target):
		_aim_at(seek_target.global_position)
#endregion


#region Movement
func tracking(delta: float) -> void:
	match state:
		State.OUTBOUND:
			if is_instance_valid(seek_target):
				if _has_los_to(seek_target):
					_steer_toward(seek_target.global_position, delta)
				else:
					_get_path()
		State.RETURN, State.AWAIT_PARRY:
			# Keep velocity so the bullet flies past the player (no re-aim each frame).
			pass
		_:
			pass

	var collision := move_and_collide(velocity * delta)
	if collision:
		_resolve_collision(collision)

	check_parry_window()


## Instant set direction (spawn / return home / parry redirect).
func _aim_at(goal: Vector2) -> void:
	var dir := goal - global_position
	if dir.length() < 0.0001:
		return
	velocity = dir.normalized() * speed


## Soft aim_at: rotate toward the goal a little each frame (turn_deg_per_sec).
## Unlike _aim_at, this doesn't instantly overwrite velocity, so a wall bounce
## can actually move us before we curve back toward the target.
func _steer_toward(goal: Vector2, delta: float) -> void:
	var to_goal := goal - global_position
	if to_goal.length() < 0.0001 or velocity.length() < 0.0001:
		return
	var current := velocity.normalized()
	var desired := to_goal.normalized()
	var delta_angle := current.angle_to(desired)
	var max_turn := deg_to_rad(turn_deg_per_sec) * delta
	delta_angle = clampf(delta_angle, -max_turn, max_turn)
	velocity = current.rotated(delta_angle) * speed


func _resolve_collision(collision: KinematicCollision2D) -> void:
	var collider := collision.get_collider()
	if collider == null:
		return

	if state == State.OUTBOUND and collider.has_method("hurt"):
		collider.hurt()
		play_vfx()
		state = State.RETURN
		if is_instance_valid(player):
			_aim_at(player.global_position)
		return

	# Walls / geometry.
	velocity = velocity.bounce(collision.get_normal())
	if velocity.length() > 0.0001:
		velocity = velocity.normalized() * speed
#endregion


#region Targeting
func find_target() -> void:
	# Refresh — enemies queue_free() on hurt, so a cached list goes stale.
	targets = get_tree().get_nodes_in_group("enemies")
	best_distance = INF
	seek_target = null
	for enemy in targets:
		if not is_instance_valid(enemy):
			continue
		distance = enemy.global_position.distance_to(global_position)
		if distance < best_distance:
			best_distance = distance
			seek_target = enemy


func check_parry_window() -> void:
	if not is_instance_valid(player):
		return
	var parry_radius := speed * parry_window_sec * 0.5
	var dist := global_position.distance_to(player.global_position)
	# Enter the window once close enough while returning.
	if state == State.RETURN and dist <= parry_radius:
		state = State.AWAIT_PARRY
	elif state == State.AWAIT_PARRY and dist > parry_radius:
		state = State.MISSED

	if state == State.AWAIT_PARRY and Input.is_action_just_pressed("parry"):
		find_target()
		if not is_instance_valid(seek_target):
			return
		state = State.OUTBOUND
		_aim_at(seek_target.global_position)
#endregion


func play_vfx():
	pass # To be used later
	
func _has_los_to(target: Node2D) -> bool:
	var space := get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(global_position, target.global_position)
	query.collide_with_areas = false
	query.collision_mask = 1 # world
	query.exclude = [self]
	var hit := space.intersect_ray(query)
	return hit.is_empty()  # nothing between you and the target point

func _get_path():
	var astar_grid := AStarGrid2D.new()
	var grow_region = Rect2i(4, 4, 8, 8).grow(4)
	astar_grid.region = grow_region
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.offset = Vector2(32, 32)
	astar_grid.update()
	for cell in world_tiles.get_used_cells():
		astar_grid.set_point_solid(cell, true)
	
