extends RigidBody3D
var facing

@onready var monitor: Area3D = $Monitor
@onready var aplayer: AnimationPlayer = $AnimationPlayer
var exploding = false
var exploded = false

@onready var cast: AudioStreamPlayer = $Cast
@onready var pop: AudioStreamPlayer = $Pop

var color:String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cast.play()
	facing = global_rotation
	apply_central_impulse(facing/10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !exploding:
		var forward_dir = -global_transform.basis.z.normalized()
		global_translate(forward_dir)
	#Collision
	if monitor.has_overlapping_bodies():
		var collisions = monitor.get_overlapping_bodies()
		for collision in collisions:
			if collision.is_in_group("Collidable_enviroment"):
				if !exploding:
					exploding = true
					if !aplayer.is_playing(): 
						pop.play()
						aplayer.play("explode")
						var e_time = aplayer.get_section_end_time()
						await get_tree().create_timer(e_time).timeout
						exploded = true
					print("hit")
	if exploded:
		queue_free()
		
		
