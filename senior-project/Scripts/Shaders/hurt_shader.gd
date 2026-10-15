extends ColorRect

@export var hurt_material: ShaderMaterial

## Call this when the player takes damage. strength ~0.6–1.0 for a sharp hit,
## lower for a graze. duration controls how long it takes to fade back out.
func flash_damage(strength: float, duration: float = 0.6) -> void:
	var tw := create_tween()
	tw.tween_method(
		func(v): hurt_material.set_shader_parameter("max_alpha", v),
		strength, 0.0, duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
