extends RigidBody3D
var facing

@onready var monitor: Area3D = $Monitor
@onready var aplayer: AnimationPlayer = $AnimationPlayer
var exploding = false
var exploded = false

@onready var cast: AudioStreamPlayer = $Cast
@onready var pop: AudioStreamPlayer = $Pop
@onready var mesh: MeshInstance3D = $Mesh

#materials
const GREEN_ORB = preload("uid://cw7bcghcy0sgq")
const RED_ORB = preload("uid://cev8xw6mbfnqq")

@export var my_materials: Array[Material]
var current_material: Material

enum SPELLTYPE{
	GreenOrb,
	RedOrb,
	Fireball
}
@export var spell_type: SPELLTYPE
var spell_name:String

func setspell(spell:String):
	var material_num = 0
	match spell:
		"GreenOrb":
			spell_type = SPELLTYPE.GreenOrb
			material_num = 0
			#Mesh.set_surface_override_material(0,GREEN_ORB)
		"RedOrb":
			spell_type = SPELLTYPE.RedOrb
			material_num = 1
		"Fireball":
			spell_type = SPELLTYPE.Fireball
	current_material = my_materials[material_num]
	spell_name = spell
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cast.play()
	facing = global_rotation
	apply_central_impulse(facing/10)
	mesh.set_surface_override_material(0,current_material)

func explode():
	if !exploding:
					exploding = true
					if !aplayer.is_playing(): 
						pop.play()
						aplayer.play("explode")
						var e_time = aplayer.get_section_end_time()
						await get_tree().create_timer(e_time).timeout
						exploded = true
					print("hit")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !exploding:
		var forward_dir = -global_transform.basis.z.normalized()
		global_translate(forward_dir)
	#Collision
	if monitor.has_overlapping_bodies() and !exploding:
		#print(str(monitor.get_overlapping_bodies()))
		var collisions = monitor.get_overlapping_bodies()
		for collision in collisions:
			if collision.is_in_group("Collidable_enviroment"):
				explode()
			elif collision is Enemy:
				print("enemy")
				explode()
				collision.got_hit(str(spell_name))
	if exploded:
		queue_free()
		
		
