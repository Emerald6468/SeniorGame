extends Control

@onready var speed: Label = $CanvasLayer/MarginContainer/Speed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var rounded = snappedf(get_parent().cur_speed,0.01)
	speed.text = "Speed: " + str(rounded)
