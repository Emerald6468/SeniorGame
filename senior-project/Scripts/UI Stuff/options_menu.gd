extends Control



func _on_volume_pressed() -> void:
	# When volume button is pressed, the current scene changes to the volume UI.
	
	get_tree().change_scene_to_file("res://Scenes/Testing/Ground Zero - Raymond/Volume_UI.tscn")


func _on_back_pressed() -> void:
	# When back button is pressed, the current scene changes to the main menu.
	
	get_tree().change_scene_to_file("res://Scenes/Testing/Ground Zero - Raymond/Menu.tscn")


func _on_screen_resolution_pressed() -> void:
	# When resolution button is pressed, the current scene changes to the screen resolution.
	
	get_tree().change_scene_to_file("res://Scenes/Testing/Ground Zero - Raymond/Screen_Resolution.tscn")
