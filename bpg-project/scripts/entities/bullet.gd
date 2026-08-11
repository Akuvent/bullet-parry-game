extends CharacterBody2D
## Homing bullet: outbound toward locked enemy, bounce on walls, return / await parry.

#region State machine
enum State { OUTBOUND, RETURN, AWAIT_PARRY, REDIRECT }
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

@export var parry_treshold = 300


#region Lifecycle
func _ready() -> void:
	motion_mode = MOTION_MODE_FLOATING


func _physics_process(delta: float) -> void:
	speed = Heat.heat
	tracking(delta)
	print(state)


func setup(p) -> void:
	player = p
	find_target()
	if is_instance_valid(seek_target):
		_aim_at(seek_target.global_position)
#endregion


#region Movement
func tracking(delta: float) -> void:
	match state:
		State.OUTBOUND:
			if is_instance_valid(seek_target):
				_aim_at(seek_target.global_position)
		State.RETURN, State.AWAIT_PARRY:
			# Keep velocity so the bullet flies past the player (no re-aim each frame).
			pass
		_:
			pass

	var collision := move_and_collide(velocity * delta)
	if collision:
		_resolve_collision(collision)

	check_parry_window()


func _aim_at(goal: Vector2) -> void:
	var dir := goal - global_position
	if dir.length() < 0.0001:
		return
	velocity = dir.normalized() * speed


func _goal_position() -> Vector2:
	match state:
		State.OUTBOUND:
			return seek_target.global_position
		State.RETURN, State.AWAIT_PARRY:
			return player.global_position
		_:
			return global_position


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
	# Enter the window once close enough while returning.
	if state == State.RETURN and global_position.distance_to(player.global_position) <= parry_treshold:
		state = State.AWAIT_PARRY
	if state == State.AWAIT_PARRY and Input.is_action_just_pressed("parry"):
		find_target()
		if not is_instance_valid(seek_target):
			return
		state = State.OUTBOUND
		_aim_at(seek_target.global_position)
#endregion


func play_vfx():
	pass # To be used later
