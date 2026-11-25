extends Node3D

var level_list
var level_gen

var rooms_unlocked = 0

var cur_level
func delete_gate(level):
	var n = rooms_unlocked
	if n < len(level_list):
		level.get_node("EndPoint/BlockGate").queue_free()
		rooms_unlocked += 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_gen = get_node("LevelGen")
	level_gen.inside_manager = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("DevQuit"):get_tree().quit()
	if Input.is_action_just_pressed("Restart"):get_tree().reload_current_scene()
	#delete gate check
	if Input.is_action_just_pressed("DEVNextGate"):delete_gate(cur_level)
	if level_list != null and rooms_unlocked < len(level_list): 
		cur_level = get_node(level_list[rooms_unlocked])
		if cur_level.check_completed(): delete_gate(cur_level)

func get_levels(array: Array):
	level_list = array
	print("teeest")
