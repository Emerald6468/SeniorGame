extends CharacterBody3D

#Base Speed
const SPEED = 8.0
const JUMP_VELOCITY = 6.0

#Flexible Speed
var cur_speed
var max_speed = 20.0
var accel = 0.04
var deccel = .25

#Coyote time
var was_on_ground = false
var coyote_time_available = false
var c_start = false
var c_time = .5

#Crouch/Slide
@export var slide_curve:Curve
var slide_deccel = .03
var slide_threshold = 12.0
var is_sliding = false
var is_crouching = false
var slide_start = false
var set_speed:float
var curve_x = 0.0
var max_slide_speed:float

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

#Camera
var mouse_sensitivity = 0.4
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D

#Headbob
var BOB_FREQ: float = 3
var BOB_AMP: float = 0.03
var t_bob:float = 0.0

#Spells
@onready var right_spell_spawn: Marker3D = $Head/Camera3D/Right_Spell_Spawn
@onready var left_spell_spawn: Marker3D = $Head/Camera3D/Left_Spell_Spawn
const BASIC_SPELL = preload("uid://cyik10fgpnsng")

#Audio
@onready var running: AudioStreamPlayer = $Running
@onready var jump: AudioStreamPlayer = $Jump
@onready var jump_land: AudioStreamPlayer = $JumpLand
@onready var slide: AudioStreamPlayer = $Slide
@onready var slide_start_audio: AudioStreamPlayer = $SlideStart

func _ready() -> void:
	cur_speed = SPEED
	max_slide_speed = max_speed + 5.0
	head_level = $Head.position.y
	crouch_level = head_level - crouch_diff
	slide_level = head_level - slide_diff

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos

func coyote_time():
	if !c_start:
		c_start = true
		await get_tree().create_timer(c_time).timeout
		coyote_time_available = false

func slide_lerp():
	if slide_start:
		slide_start = false
		curve_x = 0.0
		set_speed = cur_speed
		var set_diff = set_speed - 11.9
		slide_curve.set_point_value(2,-set_diff)
		slide_start_audio.play()
	
	if cur_speed < set_speed +5.0: 
		print("rise")
		cur_speed = slide_curve.sample(curve_x) + set_speed
	elif cur_speed >= slide_threshold: 
		print("slow")
		cur_speed = slide_curve.sample(curve_x) + set_speed
	print(curve_x)
	if slide_curve.max_domain > curve_x: curve_x += .01
	else:print("done")
		

func _physics_process(delta: float) -> void:
	#QUIT GAME COMMAND/CTRL X
	if Input.is_action_just_pressed("DevQuit"):get_tree().quit()
	
	#controlls mouse
	if !Global.InsideMenu: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

#region Gravity and Jumping
	# Add the gravity.
	if not is_on_floor():
		#increase fall with shift
		var mod = 1.0
		if Input.is_action_pressed("Slide") and !is_sliding: mod += 2.0
		velocity += get_gravity() * delta * mod
	
	# Handle jump.
	if is_on_floor(): 
		if !was_on_ground: jump_land.play()
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
		velocity.y = JUMP_VELOCITY
	
	#Wall Jump
	elif Input.is_action_just_pressed("Jump") and is_on_wall_only():
		if last_wall_jumped != last_collision or !block_walls:
			print("walljump")
			block_walls = true
			last_wall_jumped = last_collision
			print(str(last_wall_jumped))
			jump.play()
			velocity.y = JUMP_VELOCITY
		#print(str(coyote_time_available))
#endregion

#region Movement
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * cur_speed
		velocity.z = direction.z * cur_speed
		if is_on_floor():
			if !running.playing:running.play()
			if !is_crouching and !is_sliding: cur_speed = move_toward(cur_speed,max_speed,accel)
			if Input.is_action_pressed("Slide"):
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
					print("slide")
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
		velocity.x = move_toward(velocity.x, 0, cur_speed)
		velocity.z = move_toward(velocity.z, 0, cur_speed)
	if !is_on_floor():
		cur_speed = move_toward(cur_speed,SPEED,deccel/10)
		running.stop()
	var speed_diff = cur_speed - max_slide_speed
	if cur_speed > max_slide_speed: cur_speed = move_toward(cur_speed,max_slide_speed,speed_diff/5)
	
	
	#Head bob
	t_bob += delta * velocity.length() * float(is_on_floor()) * float(!is_sliding)
	camera.transform.origin = _headbob(t_bob)
		
	move_and_slide()
#endregion
	
#region Combat
	#Combat
	#Attacks
	if Input.is_action_just_pressed("Fire_Right") and !get_node("UI").right_casting:
		print("fire right")
		get_node("UI").wand_animation("right","Cast_Spell")
		var basic_spell = BASIC_SPELL.instantiate()
		get_parent().add_child(basic_spell)
		basic_spell.global_position = right_spell_spawn.global_position
		basic_spell.global_rotation = right_spell_spawn.global_rotation
	
	if Input.is_action_just_pressed("Fire_Left") and !get_node("UI").left_casting:
		print("fire left")
		get_node("UI").wand_animation("left","LCast_Spell")
		var basic_spell = BASIC_SPELL.instantiate()
		get_parent().add_child(basic_spell)
		#var material = basic_spell.get_node("Mesh").get_surface_material(0)
		#var new_color = Color("Red")
		#basic_spell.get_node("Mesh").set_surface_material(0,new_color)
		#basic_spell.get_node("Mesh").albedo_color.set_color(new_color)
		basic_spell.global_position = left_spell_spawn.global_position
		basic_spell.global_rotation = left_spell_spawn.global_rotation
#endregion


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		head.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		head.rotation_degrees.x = clampf(head.rotation_degrees.x,-70,90)
