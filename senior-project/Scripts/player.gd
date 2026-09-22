extends CharacterBody3D

#Base Speed
const SPEED = 8.0
const JUMP_VELOCITY = 4.5

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

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos
	
func _physics_process(delta: float) -> void:
	#QUIT GAME COMMAND/CTRL X
	if Input.is_action_just_pressed("DevQuit"):get_tree().quit()
	
	#controlls mouse
	if !Global.InsideMenu: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if !running.playing and is_on_floor():running.play()
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if !direction or !is_on_floor():running.stop()
	
	#Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
		
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		head.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		head.rotation_degrees.x = clampf(head.rotation_degrees.x,-70,90)
