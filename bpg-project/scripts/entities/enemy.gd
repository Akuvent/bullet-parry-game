extends CharacterBody2D
## First enemy type for the vertical slice (placeholder until variants exist).
## Lives in group "enemies" so the bullet can lock the nearest one.

func _ready() -> void:
	add_to_group("enemies")


## Instant kill for the vertical slice - no HP, no hit flash.
func hurt() -> void:
	self.queue_free()
