class_name Enemy
extends CharacterBody3D
@export var max_health:float = 100
var health: float = max_health
var knockback_velocity:Vector3
var deccel = .1

enum ENEMY_STATES{
	Idle,
	Chasing,
	Dead
}
@export var enemy_state: ENEMY_STATES

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func got_hit(spell: String,damage: float):
	match spell:
		"Fireball":
			health -= damage
			print("ouch a " + spell + " " + str(health))
		"GreenOrb":
			health -= damage
			print("ouch a " + spell + " "  + str(health))
		"RedOrb":
			health -= damage
			print("ouch a " + spell + " "  + str(health))
			
			
func _physics_process(delta: float) -> void:
	#falling
	if !is_on_floor(): velocity += get_gravity() * delta
	#fireball knockback
	velocity += knockback_velocity
	velocity.x = move_toward(velocity.x, 0, deccel)
	velocity.z = move_toward(velocity.z, 0, deccel)
	print("velocity: " + str(velocity))
	move_and_slide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	if enemy_state != ENEMY_STATES.Dead:
		if health < 0:
			enemy_state = ENEMY_STATES.Dead
	else:
		print("i die :(")
		queue_free()
		
		
