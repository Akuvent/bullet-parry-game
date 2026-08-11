extends Area2D
enum State { OUTBOUND, HIT, RETURN, AWAIT_PARRY, REDIRECT }
var state: State = State.OUTBOUND
var seek_target: Node2D  # locked enemy while outbound
var targets:= []
var player: Node2D       # set on spawn / _ready
var speed : float = Heat.heat
var best_distance : float = INF
var distance : float = INF

func _physics_process(delta):
	tracking(delta)


func _goal_position() -> Vector2:
	match state:
		State.OUTBOUND:
			return seek_target.global_position
		State.RETURN, State.AWAIT_PARRY:
			return player.global_position
		_:
			return global_position  # Hit / Redirect: often don't fly, or handle apart

func tracking(delta: float) -> void:
	var goal := _goal_position()
	global_position = global_position.move_toward(goal, speed * delta)

func setup(p):
	player = p
	targets = get_tree().get_nodes_in_group("enemies")
	find_target()
	
func find_target():
		for enemy in targets:
			distance = enemy.global_position.distance_to(self.global_position)
			if distance < best_distance:
				best_distance = distance
				seek_target = enemy
