extends Node3D

var level_list
var level_gen

var rooms_unlocked = 0

func delete_gate():
	var n = rooms_unlocked
	if n < len(level_list):
		var level = get_node(level_list[n])
		level.get_node("EndPoint/BlockGate").queue_free()
		rooms_unlocked += 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_gen = get_node("LevelGenTest")
	level_gen.inside_manager = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("DevQuit"):get_tree().quit()
	if Input.is_action_just_pressed("Restart"):get_tree().reload_current_scene()
	if Input.is_action_just_pressed("DEVNextGate"):delete_gate()

func get_levels(array: Array):
	level_list = array
	print("teeest")
