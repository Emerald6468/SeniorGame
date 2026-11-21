extends RigidBody2D

var dragging = false
var of = Vector2(0,0).x

@onready var area_size = $"../StaticBody2D/CollisionShape2D"
@onready var area_shape = area_size.shape

@onready var half_width = area_shape.size.x / 2


func _process(_delta):
	var left_boundary = area_size.global_position.x - half_width
	var right_boundary = area_size.global_position.x + half_width
	var ballx = get_global_mouse_position().x - of
	var ball_can_move = clamp(ballx,left_boundary,right_boundary)
	
	if dragging:
		global_position.x = ball_can_move
		
	
	
	print("left: ", + left_boundary)
	print("right: ", + right_boundary)

func _on_ball_button_down() -> void:
	print("Clicked")
	dragging = true
	of = get_global_mouse_position().x - global_position.x


func _on_ball_button_up() -> void:
	dragging = false
	gravity_scale = 1
