extends Node3D

var spawn_ready = true
var spawn_time = 4.0
const GRUNT = preload("uid://d20bamxgu5rol")
const WISP = preload("uid://bjl1p1fviswuf")
var enemy_list = ["Grunt","Wisp"]
func spawn(enemy:String):
	var enemy_type
	match enemy:
		"Grunt": enemy_type = GRUNT
		"Wisp": enemy_type = WISP
	var new_enemy = enemy_type.instantiate()
	get_parent().add_child(new_enemy)
	new_enemy.global_position = global_position

func choose_enemy():
	var ran_num = randi_range(0,enemy_list.size()-1)
	return enemy_list[ran_num]

func spawner():
	if spawn_ready:
		spawn_ready = false
		await get_tree().create_timer(spawn_time).timeout
		var enemy = choose_enemy()
		spawn(enemy)
		spawn_ready = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawner()
