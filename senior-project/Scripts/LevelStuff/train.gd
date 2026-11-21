extends PathFollow3D
class_name Train

@export var speed: float = 1
@export var leader: Train
@export var leader_distance: float = 1

@onready var parent = get_parent()
@onready var max_distance =  parent.curve.get_baked_length()

var tween = create_tween()

var following = false

#func _ready() -> void:
	#var tween = create_tween()
	#tween.tween_property(self, "progress", max_distance, max_distance/speed)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Fire_Left"):
		reset_progress()
	if leader:
		if leader.progress >= leader_distance && !following:
			start_moving()
	else:
		if Input.is_action_just_pressed("Fire_Left"):
			start_moving()

func reset_progress():
	if tween:
		tween.kill()
	progress = 0
	following = false

func start_moving():
	following = true
	tween = create_tween()
	tween.tween_property(self, "progress", max_distance, max_distance/speed)
