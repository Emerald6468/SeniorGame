extends Enemy

#this enemy is going to be airborn and be a quick fodder enemy that dies quickly
#only attack is laser
@onready var ground_check: RayCast3D = $Body/GroundCheck

#attack
var just_attacked = false
var a_time = 1.0

func attack():
	if !just_attacked:
		just_attacked = true
		laser()
		await get_tree().create_timer(a_time).timeout
		just_attacked = false

func laser():
	print("laser")

func keep_off_ground():
	var touching_null = str(ground_check.get_collider()) == "<Object#null>"
	if ground_check.collide_with_bodies and !touching_null:
		#print("near floor")
		#print(str(ground_check.get_collider()))
		position.y += .5

func _physics_process(delta: float) -> void:
	super(delta)
	keep_off_ground()
	if close_enough: attack()
