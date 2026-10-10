extends Control


func _on_play_pressed() -> void:
	# When play button is pressed, the current scene changes to arena 1.
	
	get_tree().change_scene_to_file("res://Scenes/Zones/Zone1/Arenas/arena_1.tscn")


func _on_options_pressed() -> void:
	# When options button is pressed, the current scene changes to the options menu.
	
	get_tree().change_scene_to_file("res://Scenes/Testing/Ground Zero - Raymond/Options_Menu.tscn")


func _on_exit_pressed() -> void:
	# When exit is pressed, the game closes.
	
	get_tree().quit()
