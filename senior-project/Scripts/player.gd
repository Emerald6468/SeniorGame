extends CharacterBody3D

#Base Speed
const SPEED = 8.0
const JUMP_VELOCITY = 4.5

#Flexible Speed
var cur_speed
var max_speed = 26.0
var accel = 0.02
var deccel = .5

#Coyote time
var was_on_ground = false
var coyote_time_available = false
var c_start = false
var c_time = .5
#Camera
var mouse_sensitivity = 0.4
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D

#Headbob
var BOB_FREQ: float = 3
var BOB_AMP: float = 0.03
var t_bob:float = 0.0

#Audio
@onready var running: AudioStreamPlayer = $Running

func _ready() -> void:
	cur_speed = SPEED

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos

func coyote_time():
	if !c_start:
		c_start = true
		await get_tree().create_timer(c_time).timeout
		coyote_time_available = false


func _physics_process(delta: float) -> void:
	#QUIT GAME COMMAND/CTRL X
	if Input.is_action_just_pressed("DevQuit"):get_tree().quit()
	
	#controlls mouse
	if !Global.InsideMenu: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

#region Gravity and Jumping
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if is_on_floor(): 
		coyote_time_available = true
		was_on_ground = true
		c_start = false
	elif coyote_time_available and was_on_ground : 
		coyote_time()
		was_on_ground = false
	#Normal Jump
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or coyote_time_available):
		coyote_time_available = false
		velocity.y = JUMP_VELOCITY
	print(str(coyote_time_available))
#endregion

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
#region Movement
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * cur_speed
		velocity.z = direction.z * cur_speed
		if is_on_floor():
			if !running.playing:running.play()
			cur_speed = move_toward(cur_speed,max_speed,accel)
	else:
		running.stop()
		cur_speed = move_toward(cur_speed,SPEED,deccel)
		velocity.x = move_toward(velocity.x, 0, cur_speed)
		velocity.z = move_toward(velocity.z, 0, cur_speed)
	if !is_on_floor():
		cur_speed = move_toward(cur_speed,SPEED,deccel/10)
		running.stop()
	
	#Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
		
	move_and_slide()
#endregion
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		head.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		head.rotation_degrees.x = clampf(head.rotation_degrees.x,-70,90)
