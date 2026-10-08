extends Control



func _on_volume_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Testing/Ground Zero - Raymond/Volume_UI.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Testing/Ground Zero - Raymond/Menu.tscn")


func _on_screen_resolution_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Testing/Ground Zero - Raymond/Screen_Resolution.tscn")
