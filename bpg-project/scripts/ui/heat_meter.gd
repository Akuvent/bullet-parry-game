extends Node2D
## Readable expression of shared bullet/player speed (heat).
## Bind to Heat; do not keep a parallel value here.
@onready var bar := $HeatProgressBar
@export var gradient: Gradient
var lerp_speed: float = 8.0
var displayed_heat : float = 0.0


func _ready():
	displayed_heat = Heat.heat
	
	
	
func _process(delta):
	displayed_heat = lerp(displayed_heat, Heat.heat, 1.0)
	bar.value = displayed_heat
	
	var ratio: float = (displayed_heat - 200.0) / (2000.0 - 200.0)
	ratio = clamp(ratio, 0.0, 1.0)
	bar.self_modulate = gradient.sample(ratio)
