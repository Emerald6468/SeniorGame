extends RigidBody3D
var facing

@onready var monitor: Area3D = $Monitor
@onready var aplayer: AnimationPlayer = $AnimationPlayer
var exploding = false
var s_done = false
var found_collisions = false

@onready var cast: AudioStreamPlayer = $Cast
@onready var pop: AudioStreamPlayer = $Pop
@onready var mesh: MeshInstance3D = $Mesh

const EXPLOSION = preload("uid://c6f0gnsuxx2c6")

#materials
const GREEN_ORB = preload("uid://cw7bcghcy0sgq")
const RED_ORB = preload("uid://cev8xw6mbfnqq")

#spell speeds
@export_category("Spell Speeds:")
@export var green_orb_speed: float = 1.0
@export var red_orb_speed: float = 1.0
@export var fireball_speed: float = 1.0
@export var icedart_speed: float = 1.0

#casting times
@export_category("Casting Times:")
@export var green_orb_CT: float = 1.0
@export var red_orb_CT: float = 1.0
@export var fireball_CT: float = 1.0
@export var icedart_CT: float = 1.0

#spell damages
@export_category("Spell Damages:")
@export var green_orb_damage: float = 1.0
@export var red_orb_damage: float = 1.0
@export var fireball_damage: float = 1.0
@export var icedart_damage: float = 1.0

#spell costs
@export_category("Spell Costs:")
@export var green_orb_cost: float = 20.0
@export var red_orb_cost: float = 20.0
@export var fireball_cost: float = 20.0
@export var icedart_cost: float = 20.0

#spell arrays
@export_category("Cosmetic:")
@export var all_meshes: Array[Mesh]
@export var all_materials: Array[Material]
var all_speeds: Array[float]
var all_CT: Array[float]
var all_damage: Array[float]
var all_costs: Array[float]

#spell variables
var spell_num:int 
var spell_name:String
var spell_mesh: Mesh
var spell_material: Material
var spell_speed:float
var cast_time:float
var spell_damage:float
var spell_cost:float

#spell tags
var explodes:bool = false
var burns:bool = false

func setspell(spell:String):
	all_speeds = [green_orb_speed,red_orb_speed,fireball_speed,icedart_speed]
	all_CT = [green_orb_CT,red_orb_CT,fireball_CT,icedart_CT]
	all_damage = [green_orb_damage,red_orb_damage,fireball_damage,icedart_damage]
	all_costs =[green_orb_cost,red_orb_cost,fireball_cost,icedart_cost]
	match spell:
		"GreenOrb":
			spell_num = 0
		"RedOrb":
			spell_num = 1
		"Fireball":
			spell_num = 2
			explodes = true
			burns = true
		"IceDart":
			spell_num = 3
	#Setting Spells variables
	spell_name = spell
	spell_mesh = all_meshes[spell_num]
	spell_material = all_materials[spell_num]
	spell_speed = all_speeds[spell_num]
	cast_time = all_CT[spell_num]
	spell_damage = all_damage[spell_num]
	spell_cost = all_costs[spell_num]

func get_cooldown():
	return cast_time

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cast.play()
	facing = global_rotation
	apply_central_impulse(facing)
	mesh.set_mesh(spell_mesh)
	mesh.set_surface_override_material(0,spell_material)
	if spell_name == "IceDart": mesh.rotate_x(deg_to_rad(-90))

func dissapear():
	if explodes and !exploding:
		exploding = true
		if explodes:
			var explosion = EXPLOSION.instantiate()
			add_child(explosion)
		if !aplayer.is_playing(): 
			pop.play()
			aplayer.play("explode")
			var e_time = aplayer.get_section_end_time()
			await get_tree().create_timer(e_time).timeout
			s_done = true
		print("hit")
	else:
		pop.play()
		await get_tree().create_timer(.1).timeout
		s_done = true
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !exploding:
		var forward_dir = -global_transform.basis.z.normalized()
		var speed = (forward_dir/3) * spell_speed
		#print("Spell: " + spell_name + " speed " + str(spell_speed) + " at " + str(speed))
		global_translate(speed)
	#Collision
	if monitor.has_overlapping_bodies() and !exploding and !found_collisions:
		#print(str(monitor.get_overlapping_bodies()))
		var collisions = monitor.get_overlapping_bodies()
		for collision in collisions:
			if collision.is_in_group("Collidable_enviroment"):
				dissapear()
			elif collision is Enemy:
				print("enemy")
				if burns: collision.on_fire = true;collision.b_timer = true
				dissapear()
				collision.got_hit(spell_name,spell_damage)
		found_collisions = true
	if s_done:
		queue_free()
		
		
