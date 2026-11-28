class_name Zone
extends Node3D

#Files
const BLUE_LEVEL = preload("uid://3aa0r21ha8ah")
const GREEN_LEVEL = preload("uid://jyuotl0htmha")
const RED_LEVEL = preload("uid://dkn1pns4yx8p4")
const YELLOW_LEVEL = preload("uid://b1v7cs16p6l4u")
const PURPLE_LEVEL = preload("uid://cnxhphcxjtvje")
const ORANGE_LEVEL = preload("uid://dqch6kl6gskip")

#Zone 1
const ARENA_1 = preload("uid://co8q4ra67bsci")
const ARENA_2 = preload("uid://cjtx2jjncontf")
const ARENA_3 = preload("uid://cbe6ru80h2jus")

const HALL_1 = preload("uid://ddc4ekte7mymd")
const HALL_2 = preload("uid://c2n3fl1m24dy1")
const HALL_3 = preload("uid://bvb3cli4cxmvb")

@export_category("DEV TEST")
@export var birdeye = false
@export var colorlevels = false
@export var swapsegments = false
#Lists of levels
#Zone 1
var all_zone1_levels: Array[PackedScene]
var all_zone1_hallways: Array[PackedScene]
var all_zone1_arenas: Array[PackedScene]
var cur_hall_choices: Array[PackedScene]
var cur_arena_choices: Array[PackedScene]

#to control level gen
@export var level_length = 6
var current_room = 0
@export_category("Zone")
@export var current_zone = 1
var gen_num = 1
var zone_array: Array[PackedScene]
var level_list: Array[String]
var next_position = Vector3(0,0,0)
var next_rotation = Vector3(0,0,0)

#connect to manager
var inside_manager = false

func pick_zone_layout():
	if gen_num < level_length+1:
		var segment_order
		if !swapsegments: segment_order = gen_num % 2 != 0
		else: segment_order = gen_num % 2 == 0
		if segment_order:
			cur_hall_choices.shuffle()
			zone_array.append(cur_hall_choices[0])
			cur_hall_choices.pop_front()
		else:
			cur_arena_choices.shuffle()
			zone_array.append(cur_arena_choices[0])
			cur_arena_choices.pop_front()
		gen_num+=1
	else: return true
	return false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if colorlevels:
		all_zone1_levels = [BLUE_LEVEL,GREEN_LEVEL,RED_LEVEL,YELLOW_LEVEL,ORANGE_LEVEL,PURPLE_LEVEL]
		all_zone1_hallways = [YELLOW_LEVEL,GREEN_LEVEL,PURPLE_LEVEL]
		all_zone1_arenas = [RED_LEVEL,BLUE_LEVEL,ORANGE_LEVEL]
	else:
		all_zone1_levels = [ARENA_1,ARENA_2,ARENA_3,HALL_1,HALL_2,HALL_3]
		all_zone1_hallways = [HALL_1,HALL_2,HALL_3]
		all_zone1_arenas = [ARENA_1,ARENA_2,ARENA_3]
	match current_zone:
		1:
			cur_hall_choices = all_zone1_hallways
			cur_arena_choices = all_zone1_arenas
	
var s_num = 0
func spawn_levels():
	if s_num < level_length:
		var new_level = zone_array[s_num].instantiate()
		add_sibling(new_level)
		if s_num != 0:
			new_level.get_node("Player").queue_free()
			new_level.get_node("DirectionalLight3D").queue_free()
			new_level.get_node("WorldEnvironment").queue_free()
		new_level.global_position = next_position
		new_level.global_rotation = next_rotation
		#match s_num:
			#0: new_level.global_position.x = 0; print(str(new_level.name))
			#1: new_level.global_position.x = 5; print(str(new_level.name))
			#2: new_level.global_position.x = 10; print(str(new_level.name))
			#3: new_level.global_position.x = 15; print(str(new_level.name))
		next_position = new_level.get_node("EndPoint").global_position
		next_rotation = new_level.get_node("EndPoint").global_rotation
		var level_name = new_level.get_level_name()
		print(str(level_name))
		level_list.append(str(level_name))
		s_num += 1
	else: return true
	return false
	
var picks_done 
var spawn_done 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if birdeye: $Camera3D.make_current()
	if Input.is_action_just_pressed("DevQuit"):get_tree().quit()
	if Input.is_action_just_pressed("Restart"):get_tree().reload_current_scene()
	picks_done = pick_zone_layout()
	if picks_done: spawn_done = spawn_levels();
	if spawn_done:
		print("START      " + str(level_list))
		if inside_manager: 
			get_parent().get_levels(level_list)
			queue_free()
	
