extends Enemy

#this enemy is going to be airborn and be a quick fodder enemy that dies quickly
#only attack is laser
@onready var ground_check: RayCast3D = $GroundCheck
const LASER = preload("uid://dynsgtskds74k")
@onready var laser_spawn_point: Marker3D = $"Body/Mesh/LaserSpawn Point"

#attack
var just_attacked = false
var a_time = 1.0

func attack():
	if !just_attacked:
		just_attacked = true
		firelaser()
		await get_tree().create_timer(a_time).timeout
		just_attacked = false

func firelaser():
	print("laser")
	var laser = LASER.instantiate()
	#laser.angle = basis
	laser.target = player_pos
	get_tree().root.add_child(laser)
	laser.global_position = laser_spawn_point.global_position
	laser.global_rotation = laser_spawn_point.global_rotation
	

func keep_off_ground():
	var touching_null = str(ground_check.get_collider()) == "<Object#null>"
	if ground_check.collide_with_bodies and !touching_null:
		#print("near floor")
		#print(str(ground_check.get_collider()))
		position.y += 0.1

func _physics_process(delta: float) -> void:
	super(delta)
	keep_off_ground()
	if enemy_state == ENEMY_STATES.Chasing: attack()
