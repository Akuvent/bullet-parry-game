extends CharacterBody2D
## Player: move (speed tied to heat) + parry on bullet return.
var bullet_scene := preload("res://scenes/entities/bullet.tscn")
var bullet = bullet_scene.instantiate()
var speed : float = Heat.heat
const JUMP_VELOCITY = -800.0
## How long to hold the land pose (seconds). Bump if it still feels snappy.
const LAND_HOLD := 0.2
@onready var sprite = $AnimatedSprite2D
@onready var muzzle: Marker2D = $Muzzle
@export var facing_right := true
var can_shoot = true
## Editor position is for facing right; X is mirrored when facing left.
var _muzzle_offset := Vector2.ZERO
var was_on_floor := true
var _landing := false
var _land_timer := 0.0
var bullet_left := true

func _ready() -> void:
	_muzzle_offset = muzzle.position
	_apply_facing()


func _physics_process(delta: float) -> void:
	
	was_on_floor = is_on_floor()

	if not was_on_floor:
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("move_up") and was_on_floor:
		velocity.y = JUMP_VELOCITY
		_landing = false
	
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		var move_speed := speed * 1.5 if Input.is_action_pressed("run") else speed
		velocity.x = direction * move_speed
		facing_right = direction > 0
		_apply_facing()
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if Input.is_action_just_pressed("fire") and bullet_left and can_shoot:
		bullet.global_position = muzzle.global_position
		get_tree().current_scene.add_child(bullet)
		bullet.setup(self)
		bullet_left = false

	move_and_slide()
	_update_anims(delta)


func _apply_facing() -> void:
	# Art faces right by default; flip when looking left.
	sprite.flip_h = not facing_right
	muzzle.position = Vector2(
		_muzzle_offset.x if facing_right else -_muzzle_offset.x,
		_muzzle_offset.y
	)


#region Animation
func _update_anims(delta: float) -> void:
	if is_on_floor() and not was_on_floor:
		_landing = true
		can_shoot = false
		_land_timer = LAND_HOLD
		_set_anim(&"land_anim")

	if _landing:
		# Cancel land early: left the floor, or started walking.
		if not is_on_floor() or absf(velocity.x) > 0.1:
			_landing = false
			can_shoot = true
		else:
			_land_timer -= delta
			if _land_timer <= 0.0:
				_landing = false
				can_shoot = true
			else:
				return

	if not is_on_floor():
		if velocity.y >= 0:
			_set_anim(&"fall_anim")
		else:
			_set_anim(&"jump_anim")
	elif absf(velocity.x) > 0.1:
		if Input.is_action_pressed("run"):
			_set_anim(&"run_anim")
		else:
			_set_anim(&"walk_anim")
	else:
		_set_anim(&"idle_anim")


func _set_anim(anim_name: StringName) -> void:
	if sprite.animation != anim_name:
		sprite.play(anim_name)
#endregion
