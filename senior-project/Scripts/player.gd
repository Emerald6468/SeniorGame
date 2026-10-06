class_name Player
extends CharacterBody3D

#Base Speed
const SPEED = 8.0
const JUMP_VELOCITY = 6.0
var knockback_velocity:Vector3

#Flexible Speed
var cur_speed
var max_speed = 17.0
var accel = 0.04
var deccel = .25
var cur_jump

#Coyote time
var was_on_ground = false
var coyote_time_available = false
var c_start = false
@export var c_time = .2

#roadrunner time
var r_available = false
@export var r_time = .1
var deccel_pause = false

#Crouch/Slide
@export var slide_curve:Curve
var slide_deccel = .03
@export var slide_threshold = 8.5
var is_sliding = false
var is_crouching = false
var slide_start = false
var set_speed:float
var curve_x = 0.0
var max_slide_speed:float
var slide_jump = 1.5

#Camera heights
var head_level:float
var crouch_level:float
var slide_level:float
var crouch_diff = .25
var slide_diff = .45

#Wall Jumping
var last_collision
var last_wall_jumped
var block_walls = false

#wall_run
var on_wall = false
@export var wall_run_mod = .6

#Camera
var mouse_sensitivity = 0.4
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D

#camera tilt
@export var tilt_degrees = 2.0
var tilt_time = 0.2
var tilting = false
var tilt_finished = false

#Headbob
var BOB_FREQ: float = 3
var BOB_AMP: float = 0.03
var t_bob:float = 0.0

#MANA
@export_category("MANA")
@export var max_mana:float = 100.0
@export var cur_mana:float
@export var mana_gain_mod:float = 1.0
var can_cast = true

#Attacks
@onready var aim_assist: RayCast3D = $Head/Camera3D/AimAssist
var target_pos:Vector3

#Spells
@export_category("SPELLS")
@onready var right_spell_spawn: Marker3D = $Head/Camera3D/Right_Spell_Spawn
@onready var left_spell_spawn: Marker3D = $Head/Camera3D/Left_Spell_Spawn
const BASIC_SPELL = preload("uid://cyik10fgpnsng")
var spell_array:Array[String] = ["GreenOrb","RedOrb","Fireball"]
enum SPELLTYPE{
	GreenOrb,
	RedOrb,
	Fireball
}
@export var left_spell_type: SPELLTYPE
@export var right_spell_type: SPELLTYPE
var left_spell:String
var right_spell:String
var can_cast_left = true
var can_cast_right = true

#Audio
@onready var running: AudioStreamPlayer = $Running
@onready var jump: AudioStreamPlayer = $Jump
@onready var jump_land: AudioStreamPlayer = $JumpLand
@onready var slide: AudioStreamPlayer = $Slide
@onready var slide_start_audio: AudioStreamPlayer = $SlideStart


func _ready() -> void:
	set_spell_type()
	cur_speed = SPEED
	cur_mana = max_mana
	max_slide_speed = max_speed + 5.0
	head_level = $Head.position.y
	crouch_level = head_level - crouch_diff
	slide_level = head_level - slide_diff

func set_spell_type():
	match left_spell_type:
		SPELLTYPE.GreenOrb: left_spell = "GreenOrb"
		SPELLTYPE.RedOrb: left_spell = "RedOrb"
		SPELLTYPE.Fireball: left_spell = "Fireball"
	match right_spell_type:
		SPELLTYPE.GreenOrb: right_spell = "GreenOrb"
		SPELLTYPE.RedOrb: right_spell = "RedOrb"
		SPELLTYPE.Fireball: right_spell = "Fireball"

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos

func headtilt(tilt:String):
	var air_mod = 1.0 
	if !is_on_floor(): air_mod = 0.7
	var tilt_move = tilt_degrees / 30 * air_mod
	var return_move = tilt_move * 6
	if !tilt_finished:
		match tilt:
			"left":
				camera.rotate_z(deg_to_rad(-tilt_move))
			"right":
				camera.rotate_z(deg_to_rad(tilt_move))
			"center":
				if camera.rotation.z > 0 : camera.rotate_z(deg_to_rad(-return_move)) #left
				if camera.rotation.z < 0 : camera.rotate_z(deg_to_rad(return_move)) #right

func coyote_time():
	if !c_start:
		c_start = true
		await get_tree().create_timer(c_time).timeout
		coyote_time_available = false

func roadrunner_time():
	if r_available:
		r_available = false
		deccel_pause = true
		await get_tree().create_timer(r_time).timeout
		deccel_pause = false

func slide_lerp():
	
	if slide_start:
		print("slide start")
		slide_start = false
		curve_x = 0.0
		set_speed = cur_speed
		#at start of slide, sets the height of the slide curve to fit with additional speed
		#does this by moving the last point down according to the difference between speed and threshold
		var set_diff = set_speed - (slide_threshold - 0.1)
		slide_curve.set_point_value(2,-set_diff)
		slide_start_audio.play()
	if slide_curve.max_domain > curve_x: curve_x += .01;print("x:"+str(curve_x) + "slide" + str(Input.is_action_pressed("Slide")) + 
	"is_slide: " + str(is_sliding))
	else:return
	if cur_speed < set_speed +5.0: 
		#print("rise")
		cur_speed = slide_curve.sample(curve_x) + set_speed
	elif cur_speed >= slide_threshold: 
		#print("slow")
		cur_speed = slide_curve.sample(curve_x) + set_speed
	

func left_spell_cooldown(left_cd):
	can_cast_left = false
	await get_tree().create_timer(left_cd,false,true).timeout
	can_cast_left = true

func right_spell_cooldown(right_cd):
	can_cast_right = false
	await get_tree().create_timer(right_cd,false,true).timeout
	can_cast_right = true

func mana_tracker(spell):
	if cur_mana > 0:
		can_cast = true
		if spell != null:
			var mana_cost = spell.spell_cost; cur_mana -= mana_cost
	else: can_cast = false

func mana_recharge():
	cur_mana += (cur_speed/60) * mana_gain_mod
	if cur_mana > max_mana: cur_mana = max_mana



func _physics_process(delta: float) -> void:
	#print(str(Input.is_action_pressed("Slide")))
	#QUIT GAME COMMAND/CTRL X
	if Input.is_action_just_pressed("DevQuit"):get_tree().quit()
	#RESTART SCENE
	if Input.is_action_just_pressed("Restart"):get_tree().reload_current_scene()
	#controlls mouse
	if !Global.InsideMenu: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

#region Gravity and Jumping
	# Add the gravity.
	if not is_on_floor():
		#increase fall with shift
		var mod = 1.0
		var wall_mod = 1.0
		if Input.is_action_pressed("Slide") and !is_sliding: mod += 2.0
		if is_on_wall(): wall_mod = wall_run_mod 
		velocity += get_gravity() * delta * mod * wall_mod
		#allow roadrunner time
		r_available = true
	
	# Handle jump.
	if is_on_floor(): 
		if !was_on_ground: jump_land.play()
		roadrunner_time()
		coyote_time_available = true
		was_on_ground = true
		c_start = false
		block_walls = false
	elif coyote_time_available and was_on_ground : 
		coyote_time()
		was_on_ground = false
	else: was_on_ground = false
	#JUMPS
	if get_slide_collision_count() > 0: last_collision = get_last_slide_collision().get_collider()
	#Normal Jump
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or coyote_time_available):
		coyote_time_available = false
		jump.play()
		if is_sliding: cur_jump *= slide_jump
		velocity.y = cur_jump
	
	#Wall Jump
	elif Input.is_action_just_pressed("Jump") and is_on_wall_only():
		if last_wall_jumped != last_collision or !block_walls:
			block_walls = true
			last_wall_jumped = last_collision
			#print(str(last_wall_jumped))
			jump.play()
			velocity.y = JUMP_VELOCITY
#endregion

#region Movement
	#keeps minimum speed
	if cur_speed < SPEED: cur_speed = SPEED
	cur_jump = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#camera rotation for tilting
	if input_dir.x != 0:
		#tilt left
		if input_dir.x > 0:
			if rad_to_deg(camera.rotation.z) <= -tilt_degrees: tilt_finished = true
			else: tilt_finished = false
			headtilt("left")
		#tilt right
		if input_dir.x < 0:
			if rad_to_deg(camera.rotation.z) >= tilt_degrees: tilt_finished = true
			else: tilt_finished = false
			headtilt("right")
	else: 
		headtilt("center")
		tilt_finished = false
	if direction:
		velocity.x = direction.x * cur_speed
		velocity.z = direction.z * cur_speed
		#mana recharge
		mana_recharge()
		if is_on_floor():
			var speed_diff = cur_speed - max_speed
			if cur_speed > max_speed and !slide_start and !deccel_pause: cur_speed = move_toward(cur_speed,max_speed,speed_diff/5)
			if !running.playing:running.play()
			#increase speed normally
			if !is_crouching and !is_sliding: cur_speed = move_toward(cur_speed,max_speed,accel)
			if Input.is_action_pressed("Slide"): #chooses slide or crouch
				if cur_speed >= slide_threshold: is_sliding = true
				else: is_crouching = true
			else: is_sliding = false;is_crouching = false
			if Input.is_action_just_pressed("Slide"):
				slide_start = true
			if is_sliding: 
				if cur_speed < slide_threshold: 
					is_sliding = false
					is_crouching = true
				else:
					slide_lerp()
					$Head.position.y = move_toward(slide_level,$Head.position.y,.03)
					if !slide.playing: slide.play()
			elif is_crouching:
				slide.stop()
				$Head.position.y = move_toward(crouch_level,$Head.position.y,.05)
			else: 
				$Head.position.y = move_toward(head_level,$Head.position.y,.2)
				slide.stop()
		
	else:
		running.stop()
		slide.stop()
		cur_speed = move_toward(cur_speed,SPEED,deccel)
		velocity.x = move_toward(velocity.x, 0, deccel*2)
		velocity.z = move_toward(velocity.z, 0, deccel*2)
	if !is_on_floor():
		cur_speed = move_toward(cur_speed,SPEED,deccel/500)
		curve_x = 0.0
		set_speed = cur_speed
		is_sliding = false
		is_crouching = false
		$Head.position.y = move_toward(head_level,$Head.position.y,.2)
		slide.stop()
		running.stop()

	#Head bob
	t_bob += delta * velocity.length() * float(is_on_floor()) * float(!is_sliding)
	camera.transform.origin = _headbob(t_bob)
		
	move_and_slide()
#endregion
	
#region Combat
	#Combat
	#Mana
	get_node("UI").cur_mana = cur_mana
	#Attacks
	var assist = false
	if aim_assist.collide_with_bodies and str(aim_assist.get_collider())!="<Object#null>":
		target_pos = aim_assist.get_collision_point();assist = true
	
	if Input.is_action_just_pressed("Fire_Right") and can_cast and can_cast_right:
		get_node("UI").wand_animation("right","Cast_Spell")
		var basic_spell = BASIC_SPELL.instantiate()
		basic_spell.setspell(right_spell)
		get_parent().add_child(basic_spell)
		var right_cd = basic_spell.get_cooldown()
		right_spell_cooldown(right_cd)
		mana_tracker(basic_spell)
		basic_spell.global_position = right_spell_spawn.global_position
		basic_spell.global_rotation = right_spell_spawn.global_rotation
		if assist:basic_spell.look_at(target_pos)
	else:mana_tracker(null)
	
	if Input.is_action_just_pressed("Fire_Left") and can_cast and can_cast_left:
		get_node("UI").wand_animation("left","LCast_Spell")
		var basic_spell = BASIC_SPELL.instantiate()
		basic_spell.setspell(left_spell)
		get_parent().add_child(basic_spell)
		var left_cd = basic_spell.get_cooldown()
		right_spell_cooldown(left_cd)
		mana_tracker(basic_spell)
		basic_spell.global_position = left_spell_spawn.global_position
		basic_spell.global_rotation = left_spell_spawn.global_rotation
		if assist:basic_spell.look_at(target_pos)
	else:mana_tracker(null)
#endregion

#Spells interactions on player
	#fireball knockback
	velocity += knockback_velocity

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		head.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		head.rotation_degrees.x = clampf(head.rotation_degrees.x,-70,90)
