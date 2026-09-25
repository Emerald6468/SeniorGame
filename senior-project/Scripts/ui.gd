extends Control

@onready var speed: Label = $CanvasLayer/MarginContainer/Speed

@onready var right_hand: AnimationPlayer = $RightHand
@onready var left_hand: AnimationPlayer = $LeftHand

var right_casting = false
var left_casting = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func wand_animation(hand,name):
	match hand:
		"right":
			if !right_hand.is_playing(): right_hand.play(str(name))
		"left":
			if !left_hand.is_playing(): left_hand.play(str(name))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var rounded = snappedf(get_parent().cur_speed,0.01)
	speed.text = "Speed: " + str(rounded)
	if right_hand.is_playing():right_casting = true
	else: right_casting = false
	if left_hand.is_playing():left_casting = true
	else: left_casting = false
