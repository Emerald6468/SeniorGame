extends Node3D
@onready var area_3d: Area3D = $Area3d

var angle : Basis
var target : Vector3
#var speed : float = 5.0

func _physics_process(delta: float) -> void:
	var forward_dir = -global_transform.basis.z.normalized()
	var speed = (forward_dir/3)
	global_translate(speed)
	#global_position.move_toward(target,speed)
	if area_3d.has_overlapping_bodies():
		var bodies = area_3d.get_overlapping_bodies()
		for body in bodies:
			if body is Player: body.got_hurt();queue_free()
func _on_lifespan_timeout() -> void:
	call_deferred("queue_free")
