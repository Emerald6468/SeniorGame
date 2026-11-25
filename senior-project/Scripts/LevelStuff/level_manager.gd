extends Node3D


@export_category("Complete Conditions")
@export var auto_complete = false
@export var defeat_all_enemies = false

@export_group("Arena")
@export var is_arena = false
@export var waves = 3
@export var enemy_per_wave = 3
var total_enemies: int
var enemies_defeated = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_arena: total_enemies = waves * enemy_per_wave


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
