extends Node
## Shared kinetum state: rises on successful parry; drives bullet + player speed.
## Cooldown / dump method is still an open design question - keep pluggable.

#region Config
@export var outbound_rise_per_sec: float = 100.0
@export var max_speed: float = 2000
var kinetum_loss_per_sec: float = 80
var fall_threshold: int = 200
#endregion


#region State
var kinetum: float = 200
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
		kinetum += outbound_rise_per_sec * delta
		kinetum = minf(kinetum, max_speed)
	elif is_loose:
		var ramp: float = 0.2
		var max_mult: float = 5
		loose_time += delta
		dump_mult = minf(1.0 + loose_time * ramp, max_mult)
		kinetum -= kinetum_loss_per_sec * dump_mult * delta
		kinetum = maxf(kinetum, fall_threshold)
#endregion


#region Combat
func set_loose(value: bool) -> void:
	is_loose = value
	if value:
		loose_time = 0.0
		dump_mult = 1.0


func parried() -> void:
	if kinetum <= 1901:
		kinetum += 100


func set_outbound_active(active: bool) -> void:
	is_outbound = active
#endregion
