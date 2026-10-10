extends CanvasLayer


func _ready() -> void:
	# When the node is ready, hide the pause menu and make the game unpaused.
	
	visible = false
	get_tree().paused = false
	

func _input(event: InputEvent) -> void:
	# Checks if the player pressed the pause key.
	
	if Input.is_action_just_pressed("Pause"):
		# If the game is not paused, hide the pause menu and resume the game.
		
		if get_tree().paused:
			visible = false
			get_tree().paused = false
		
		#If the game is paused, show the pause menu, pause the game, and make the mouse visible.
		else:
			visible = true
			get_tree().paused = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE



func _on_options_pressed() -> void:
	# Pauses the game, loads and creates an instance of the options menu, and 
	# adds it as a child of the current node.
	
		get_tree().paused = true
		var packed_scene = load("res://Scenes/Testing/Ground Zero - Raymond/Options_Menu.tscn")
		var options_instance = packed_scene.instantiate()
		add_child(options_instance)


func _on_resume_pressed() -> void:
	# When the resume button is pressed, the pause menu is hidden and the game resumes.
	
		visible = false
		get_tree().paused = false


func _on_main_menu_pressed() -> void:
	# When main menu is pressed, the game is paused and the current scene changes to the main menu.
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Testing/Ground Zero - Raymond/Menu.tscn")
