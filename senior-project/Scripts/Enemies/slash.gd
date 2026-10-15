extends Node3D

@onready var area_3d: Area3D = $Area3D

func _physics_process(delta: float) -> void:
	if area_3d.has_overlapping_bodies():
		var bodies = area_3d.get_overlapping_bodies()
		for body in bodies:
			if body is Player: body.got_hurt();queue_free()

func _on_timer_timeout() -> void:
	call_deferred("queue_free")
