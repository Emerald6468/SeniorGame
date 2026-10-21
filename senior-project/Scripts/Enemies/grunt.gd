extends Enemy

#this enemy is going to be grounded and be a quick fodder enemy that dies quickly
#only attack is melee

#attack
var just_attacked = false
var a_time = 1.0
const SLASH = preload("uid://chl0451sq85fm")
@onready var slash_spawn_point: Marker3D = $Body/Mesh/SlashSpawnPoint
@onready var melee_sound: AudioStreamPlayer3D = $Melee

func attack():
	if !just_attacked:
		just_attacked = true
		melee()
		await get_tree().create_timer(a_time).timeout
		just_attacked = false

func melee():
	melee_sound.play()
	var slash = SLASH.instantiate()
	get_tree().root.add_child(slash)
	slash.global_position = slash_spawn_point.global_position
	slash.global_rotation = slash_spawn_point.global_rotation

func _physics_process(delta: float) -> void:
	super(delta)
	if close_enough: attack()
