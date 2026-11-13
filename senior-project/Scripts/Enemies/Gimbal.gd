extends CharacterBody3D

var SPEED:float = 4.0

#Navigation
var player = null
@export var player_path:NodePath
@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D


func navigate():
	nav_agent.set_target_position(player.global_position)
	var next_nav_point = nav_agent.get_next_path_position()
	#if floats: next_nav_point.y = next_nav_point.y + 5
	#next_nav_point = keep_angle(next_nav_point,player.global_position)
	velocity = (next_nav_point - global_position).normalized() * SPEED
	print("tried")
	
func _ready() -> void:
	player = get_node(player_path)
	
func _process(delta: float) -> void:
	print("gimble" + str(velocity))
	#navigate()
	#falling
	#if !is_on_floor(): 
		#velocity += get_gravity() * delta
	move_and_slide()
