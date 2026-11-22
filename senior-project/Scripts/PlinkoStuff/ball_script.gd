extends RigidBody2D

var dragging = false
var of = Vector2(0,0).x

var inside = true

@onready var area_size = $"../StaticBody2D/CollisionShape2D"
@onready var area_shape = area_size.shape
@onready var half_width = area_shape.size.x / 2
@onready var half_height = area_shape.size.y / 2

func _checkball():
	print("inside", inside)
	var top_boundary = area_size.global_position.y - half_height
	var bottom_boundary = area_size.global_position.y + half_height
	if get_global_position().y > top_boundary and get_global_position().y < bottom_boundary:\
		inside = true
		
	else:
		inside = false	


func _process(_delta):
	
	_checkball()
	
	var left_boundary = area_size.global_position.x - half_width
	var right_boundary = area_size.global_position.x + half_width
	var ballx = get_global_mouse_position().x - of
	var ball_side_move = clamp(ballx,left_boundary,right_boundary)
	
	
	if dragging and inside:
		global_position.x = ball_side_move

func _on_ball_button_down() -> void:
	print("Clicked")
	if inside:
		dragging = true
		of = get_global_mouse_position().x - global_position.x
	


func _on_ball_button_up() -> void:
	dragging = false
	gravity_scale = 1
