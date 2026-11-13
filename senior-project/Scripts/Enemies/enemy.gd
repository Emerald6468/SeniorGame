class_name Enemy
extends CharacterBody3D
@export var max_health:float = 100
var health: float = max_health
var knockback_velocity:Vector3
var deccel = .1
var SPEED:float = 4.0
var cur_speed:float = SPEED
@onready var body: CollisionShape3D = $Body
@onready var mesh: MeshInstance3D = %Mesh



enum ENEMY_STATES{
	Idle,
	Chasing,
	Dead
}
@export var enemy_state: ENEMY_STATES

#Navigation
var player = null
@export var player_path:NodePath
@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D


#Monitor
@onready var monitor: Area3D = %Monitor
var player_pos: Vector3
var look_pos: Vector3
@onready var enemy_head: Marker3D = $Body/EnemyHead
@export var social_distance = 4.0
var close_enough = false

@export_category("EnemyTags:")
@export var chases = true
@export var immortal = false
@export var floats = false

#region Status VARS
#Status tracker
@onready var status_text: Label3D = $Status

#burning
var on_fire = false
var burn_time: float = 3.0
var b_timer = false
var burn_damage = .3

#frozen
var froze = false
var f_time = 3.0
var f_timer = false
#endregion

#region Status FUNCS
func status_tracker():
	var status_list: Array[String] = []
	if on_fire:
		status_list.append("Burning")
	if froze:
		status_list.append("Froze")
	status_text.text = ""
	if status_list: for status in status_list:
		status_text.text += status + "\n"

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

func freezing():
	var freeze_mod = 1.0
	if froze:
		freeze_mod = 0.6
		if f_timer:
			f_timer = false
			await get_tree().create_timer(f_time).timeout
			froze = false
	cur_speed = SPEED * freeze_mod


#endregion


#region Player Detection
func check_for_player():
	find_player()
	if enemy_state != ENEMY_STATES.Dead:
		var near_player = player_pos and player_pos != Vector3.ZERO
		if near_player: player_found()
		if near_player and chases: enemy_state = ENEMY_STATES.Chasing
		else: enemy_state = ENEMY_STATES.Idle

func find_player():
	if monitor.has_overlapping_bodies():
		var finds = monitor.get_overlapping_bodies()
		for find in finds:
			if find is Player:
				player_pos = find.global_position
	else: player_pos = Vector3.ZERO


func player_found():
	look_pos = player_pos
	look_pos.y = global_position.y
	not_to_close(look_pos)
	if !close_enough and (is_on_floor() or floats):
		#print(str(knockback_velocity))
		mesh.look_at(look_pos,Vector3(0, 1, 0),false)
	else: mesh.look_at(player_pos,Vector3(0, 1, 0),false)

func not_to_close(target):
	var cur_distance = global_position.distance_to(target)
	if cur_distance <= social_distance: close_enough = true
	else: close_enough = false

func chase_player():
	look_pos = player_pos
	look_pos.y = global_position.y
	not_to_close(look_pos)
	if !close_enough and (is_on_floor() or floats):
		#print(str(knockback_velocity))
		mesh.look_at(player_pos,Vector3(0, 1, 0),false)
		if knockback_velocity == Vector3.ZERO or !knockback_velocity:
			navigate()
			
			#velocity = (look_pos - global_position).normalized() * cur_speed #move toward player
	else: pass;#print(str(knockback_velocity))

func navigate():
	nav_agent.set_target_position(player.global_position)
	var next_nav_point = nav_agent.get_next_path_position()
	#if floats: next_nav_point.y = next_nav_point.y + 5
	#next_nav_point = keep_angle(next_nav_point,player.global_position)
	velocity = (next_nav_point - global_position).normalized() * SPEED
#for wisp
var desired_angle = 35
func keep_angle(point,player):
	#var f_length = sqrt(pow(player.x-point.x,2)+pow(player.z-point.z,2))
	#var length = f_length
	#var floor_angle = 0
	#if point.y != player.y:
		#var opp = abs(player.y-point.y)
		#length = sqrt(pow(f_length,2) + pow(opp,2))
		#floor_angle = 90-atan2(opp,length)
	#else:floor_angle = 90
	#var player_angle = 180 - (floor_angle + desired_angle)
	#var desired_height = length/cos(floor_angle)
	#var desired_y = point.y + desired_height
	#point.y = desired_y
	point.y = player.y + 5
	return point
#endregion



func got_hit(spell: String,damage: float):
	health -= damage
	print("ouch a " + spell + " "  + str(health))

func _ready() -> void:
	player = get_node(player_path)

func _physics_process(delta: float) -> void:
	#falling
	if !is_on_floor() and !floats: 
		velocity += get_gravity() * delta
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
		if floats: get_parent().queue_free()
		queue_free()
		
		
