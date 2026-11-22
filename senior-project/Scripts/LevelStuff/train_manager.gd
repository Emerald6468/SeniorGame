extends Node3D

@onready var timer = $Timer

@export var train_arr: Array[Train]

func _on_timer_timeout() -> void:
	var train = train_arr.pick_random()
	for i in train.get_parent().get_children():
		i.reset_progress()
	train.start_moving()
