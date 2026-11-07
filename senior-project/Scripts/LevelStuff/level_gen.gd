extends Node3D

#Files
const BLUE_LEVEL = preload("uid://3aa0r21ha8ah")
const GREEN_LEVEL = preload("uid://jyuotl0htmha")
const RED_LEVEL = preload("uid://dkn1pns4yx8p4")
const YELLOW_LEVEL = preload("uid://b1v7cs16p6l4u")

#Lists of levels
#Zone 1
var all_zone1_levels: Array[PackedScene]
var all_zone1_hallways: Array[PackedScene]
var all_zone1_arenas: Array[PackedScene]

#to control level gen
var current_room = 0
var current_zone = 1
var gen_num = 0
var zone_array: Array[PackedScene]

func pick_zone_layout():
	if gen_num < 6:
		if gen_num % 2 != 0:
			all_zone1_arenas.shuffle()
			zone_array.append(all_zone1_arenas[0])
		else:
			all_zone1_hallways.shuffle()
			zone_array.append(all_zone1_hallways[0])
		gen_num+=1
	else: return true
	return false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	all_zone1_levels = [BLUE_LEVEL,GREEN_LEVEL,RED_LEVEL,YELLOW_LEVEL]
	all_zone1_hallways = [BLUE_LEVEL,GREEN_LEVEL]
	all_zone1_arenas = [RED_LEVEL,YELLOW_LEVEL]
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var picks_done = pick_zone_layout()
	if picks_done: print(str(zone_array))
