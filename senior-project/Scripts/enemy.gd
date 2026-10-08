class_name Enemy
extends CharacterBody3D
@export var max_health:float = 100
var health: float = max_health
var knockback_velocity:Vector3
var deccel = .1
var SPEED:float = 4.0
var cur_speed:float = SPEED

@export var immortal = false

enum ENEMY_STATES{
	Idle,
	Chasing,
	Dead
}
@export var enemy_state: ENEMY_STATES

#Status tracker
@onready var status_text: Label3D = $Status

#Monitor
@onready var monitor: Area3D = $Monitor
var player_pos: Vector3
@onready var enemy_head: Marker3D = $EnemyHead
@export var social_distance = 4.0
var close_enough = false

#burning
var on_fire = false
var burn_time: float = 3.0
var b_timer = false
var burn_damage = .3

#frozen
var froze = false
var f_time = 3.0
var f_timer = false

func freezing():
	var freeze_mod = 1.0
	if froze:
		freeze_mod = 0.6
		if f_timer:
			f_timer = false
			await get_tree().create_timer(f_time).timeout
			froze = false
	cur_speed = SPEED * freeze_mod

func not_to_close(target):
	var cur_distance = global_position.distance_to(target)
	if cur_distance <= social_distance: close_enough = true
	else: close_enough = false
	#if close_enough: print("to close")
	#else: print("still going")

func status_tracker():
	var status_list: Array[String] = []
	if on_fire:
		status_list.append("Burning")
	if froze:
		status_list.append("Froze")
	status_text.text = ""
	if status_list: for status in status_list:
		status_text.text += status + "\n"


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
	var look_pos = player_pos
	look_pos.y = enemy_head.position.y
	not_to_close(look_pos)
	if !close_enough and is_on_floor():
		#print(str(knockback_velocity))
		look_at(look_pos,Vector3(0, 1, 0),false)
		if knockback_velocity == Vector3.ZERO or !knockback_velocity:
			velocity = (look_pos - position).normalized() * cur_speed #move toward player
	else: print(str(knockback_velocity))



func burning():
	if on_fire:
		#if health>burn_damage:
		health -= burn_damage
		if b_timer:
			b_timer = false
			await get_tree().create_timer(burn_time * .667).timeout
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
	if knockback_velocity == Vector3.ZERO or !knockback_velocity:
		velocity.x = move_toward(velocity.x, 0, deccel)
		velocity.z = move_toward(velocity.z, 0, deccel)
	#fireball burn
	burning()
	#ice dart freeze
	freezing()
	#check for player nearby
	check_for_player()
	
	if enemy_state == ENEMY_STATES.Chasing: chase_player()
	
	
	move_and_slide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	status_tracker()
	
	if enemy_state != ENEMY_STATES.Dead:
		if health < 0:
			if !immortal:enemy_state = ENEMY_STATES.Dead
			else: health = max_health
	else:
		print("i die :(")
		queue_free()
		
		
