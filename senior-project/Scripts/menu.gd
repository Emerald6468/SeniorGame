extends Control


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Testing/ZanderTests/BasicMovementTest.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Testing/Ground Zero - Raymond/Options_Menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
