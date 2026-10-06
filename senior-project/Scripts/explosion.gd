extends Area3D

const SPELL_RAY = preload("uid://8tqosv5tarkr")
var explosion_time = 1
@onready var boom: AudioStreamPlayer = $Boom
var found_collisions = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("test")
	boom.play()
	await get_tree().create_timer(explosion_time).timeout
	queue_free()

func get_knock(target,direction,force):
	target.knockback_velocity = direction * force
	await get_tree().create_timer(0.1).timeout
	target.knockback_velocity = Vector3.ZERO

func get_distance(point):
	return global_position.distance_to(point)

func get_direction(point):
	var knockback_direction = global_position.direction_to(point)
	return knockback_direction

func make_ray(point):
	var ray = SPELL_RAY.instantiate()
	var ray_distance = get_distance(point)
	add_child(ray)
	ray.look_at(point,Vector3(0, 1, 0),false)
	if ray.is_colliding():
		var closest_hit = ray.get_collision_point()
		return closest_hit
	else: return ray_distance

func get_knockback(target,point):
	var knockback_direction = get_direction(point)
	var knockback_distance = make_ray(point)
	get_knock(target,knockback_direction,knockback_distance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var body_list
	if has_overlapping_bodies() and !found_collisions:
		body_list = get_overlapping_bodies()
		for body in body_list:
			if body is Enemy or body is Player: found_collisions = true
			if body is Enemy:
				var point = body.global_position
				get_knockback(body,point)
			if body is Player:
				var point = body.get_node("Head").global_position
				print(str(point))
				get_knockback(body,point)
