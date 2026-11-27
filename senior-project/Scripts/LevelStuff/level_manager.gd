class_name Level
extends Node3D


@export_category("Complete Conditions")
@export var auto_complete = false
@export var defeat_all_enemies = false

@export_group("Arena")
@export var is_arena = false
@export var waves = 1
@export var enemy_per_wave = 3
@export var wave_time = 4.0
var total_enemies: int
var enemies_defeated = 0
var nest_list
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	total_enemies = waves * enemy_per_wave
	if is_arena: nest_list = get_children_of_type(self,Nest)
	multi_waves()
	#print(nest_list)


# Note: passing a value for the type parameter causes a crash
static func get_children_of_type(node: Node, child_type):
	var list = []
	for i in range(node.get_child_count()):
		var child = node.get_child(i)
		if is_instance_of(child,child_type):
			list.append(child)
	return list

#enemy waves
func spawn_wave():
	nest_list.shuffle()
	for i in range(enemy_per_wave):
		nest_list[i].spawner()
		print("i spawned")
		
func multi_waves():
	for i in range(waves):
		spawn_wave()
		await get_tree().create_timer(wave_time).timeout
		print("wave done")
	print("done spawning")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(str(enemies_defeated))
	pass

func get_level_name():
	return self.name
	
func check_completed():
	if auto_complete:
		return true
	if defeat_all_enemies:
		if enemies_defeated >= total_enemies:
			return true
	return false
