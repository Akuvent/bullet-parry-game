extends Node
## Shared heat state: rises on successful parry; drives bullet + player speed.
## Cooldown / dump method is still an open design question - keep pluggable.

#region Config
@export var outbound_rise_per_sec: float = 100.0
var heat_loss_per_sec: float = 80
var fall_threshold: int = 200
#endregion


#region State
var heat: float = 1000.0
var is_loose: bool = false
var is_outbound: bool = false
## Ramp applied while loose; persists across frames, reset in set_loose().
var dump_mult: float = 0
## Seconds spent in the current loose stretch; drives dump_mult.
var loose_time: float = 0
#endregion


#region Lifecycle
func _process(delta: float) -> void:
	if is_outbound:
		heat += outbound_rise_per_sec * delta
	elif is_loose:
		var ramp: float = 0.8
		var max_mult: float = 5
		loose_time += delta
		dump_mult = minf(1.0 + loose_time * ramp, max_mult)
		heat -= heat_loss_per_sec * dump_mult * delta
		heat = maxf(heat, fall_threshold)
#endregion


#region Combat
func set_loose(value: bool) -> void:
	is_loose = value
	if value:
		loose_time = 0.0
		dump_mult = 1.0
	# TODO: ramp dump multiplier while loose; clear on parry / grapple latch.


func parried() -> void:
	heat += 80


func set_outbound_active(active: bool) -> void:
	is_outbound = active
#endregion
