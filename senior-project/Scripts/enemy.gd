class_name Enemy
extends CharacterBody3D
@export var max_health:float = 100
var health: float = max_health
var knockback_velocity:Vector3
var deccel = .1
var speed:float = 4.0

enum ENEMY_STATES{
	Idle,
	Chasing,
	Dead
}
@export var enemy_state: ENEMY_STATES

#Status tracker
@onready var status: Label3D = $Status

#Monitor
@onready var monitor: Area3D = $Monitor
var player_pos: Vector3
@onready var enemy_head: Marker3D = $EnemyHead


#burning
var on_fire = false
var burn_time: float = 3.0
var b_timer = false
var burn_damage = .3

func status_tracker():
	if on_fire:
		status.text = "On Fire"
	else: status.text = ""

func find_player():
	if monitor.has_overlapping_bodies():
		var bodies = monitor.get_overlapping_bodies()
		for body in bodies:
			if body is Player:
				player_pos = body.global_position
	else: player_pos = Vector3.ZERO

func check_for_player():
	find_player()
	if enemy_state != ENEMY_STATES.Dead:
		if player_pos and player_pos != Vector3.ZERO: enemy_state = ENEMY_STATES.Chasing
		else: enemy_state = ENEMY_STATES.Idle

func chase_player():
	print("i be chasing")
	var look_pos = player_pos
	look_pos.y = enemy_head.position.y
	look_at(look_pos,Vector3.UP,false)
	velocity = (player_pos - position).normalized() * speed

func burning():
	if on_fire:
		#if health>burn_damage:
		health -= burn_damage
		if b_timer:
			b_timer = false
			await get_tree().create_timer(burn_time * .667).timeout
			print("test")
			burn_damage = burn_damage * (.667)
			await get_tree().create_timer(burn_time/3).timeout
			burn_damage = burn_damage * 1.5
			on_fire = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func got_hit(spell: String,damage: float):
	health -= damage
	print("ouch a " + spell + " "  + str(health))

func _physics_process(delta: float) -> void:
	#falling
	if !is_on_floor(): velocity += get_gravity() * delta
	#fireball knockback
	velocity += knockback_velocity
	velocity.x = move_toward(velocity.x, 0, deccel)
	velocity.z = move_toward(velocity.z, 0, deccel)
	#fireball burn
	burning()
	
	#check for player nearby
	check_for_player()
	
	if enemy_state == ENEMY_STATES.Chasing: chase_player()
	
	
	move_and_slide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	status_tracker()
	
	if enemy_state != ENEMY_STATES.Dead:
		if health < 0:
			enemy_state = ENEMY_STATES.Dead
	else:
		print("i die :(")
		queue_free()
		
		
