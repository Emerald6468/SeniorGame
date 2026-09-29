class_name Enemy
extends CharacterBody3D
@export var max_health:float = 100
var health: float = max_health

enum ENEMY_STATES{
	Idle,
	Chasing,
	Dead
}
@export var enemy_state: ENEMY_STATES

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func got_hit(spell: String):
	match spell:
		"Fireball":
			pass
		"GreenOrb":
			health -= 20
			print("ouch  " + str(health))
		"RedOrb":
			health -= 50
			print("ouch  " + str(health))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if enemy_state != ENEMY_STATES.Dead:
		if health < 0:
			enemy_state = ENEMY_STATES.Dead
	else:
		print("i die :(")
		queue_free()
		
		
