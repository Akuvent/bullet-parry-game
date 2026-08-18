extends Node2D
## Readable expression of shared bullet/player speed (heat).
## Bind to Heat; do not keep a parallel value here.
@onready var bar := $HeatProgressBar
@export var gradient: Gradient
var lerp_speed: float = 8.0
var displayed_heat : float = 0.0
var default_pos: Vector2


func _ready():
	displayed_heat = Heat.heat
	default_pos = self.position
	
func _process(delta):
	displayed_heat = lerp(displayed_heat, Heat.heat, lerp_speed * delta)
	bar.value = displayed_heat
	
	var ratio: float = (displayed_heat - 200.0) / (2000.0 - 200.0)
	ratio = clamp(ratio, 0.0, 1.0)
	bar.self_modulate = gradient.sample(ratio)
	var intensity : float = pow(ratio, 4.0) * 4
	shake(intensity, delta)
func shake(intensity: float, delta: float) -> void:
	if intensity <= 0.0:
		self.position = default_pos
		return
	var offset := Vector2(
		sin(Time.get_ticks_msec() * 0.04) * intensity,
		sin(Time.get_ticks_msec() * 0.053) * intensity
	)
	self.position = default_pos + offset
