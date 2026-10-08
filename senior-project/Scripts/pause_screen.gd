extends CanvasLayer

func _ready() -> void:
	visible = false
	get_tree().paused = false 

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause"):
		if get_tree().paused:
			visible = false
			get_tree().paused = false
		
			
		else:
			visible = true
			get_tree().paused = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


	


func _on_options_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Testing/Ground Zero - Raymond/Options_Menu.tscn")
	


func _on_resume_pressed() -> void:
		visible = false
		get_tree().paused = false


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Testing/Ground Zero - Raymond/Menu.tscn")
