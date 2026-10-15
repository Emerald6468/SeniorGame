extends StaticBody3D

#melt timer
var m_timer = false
var m_time = 3.0

#latch to floor
@onready var ray: RayCast3D = $RayCast3D
var distance_from_floor

func find_floor():
	#print("test")
	#print("y: " + str(global_position.y))
	global_position.y = 1.01
	if ray.is_colliding():
		#print("test2")
		var collision = ray.get_collider()
		if collision.is_in_group("Floor"):
			var floor_y = collision.y
			print("floor y")
			global_position.y = floor_y
			#distance_from_floor = global_position.distance_to(ray.get_collision_point())

func melt():
	if m_timer:
		m_timer = false
		await get_tree().create_timer(m_time).timeout
		queue_free()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	m_timer = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	melt()
