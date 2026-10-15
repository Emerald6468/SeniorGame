extends Control

@onready var options_menu = $VBoxContainer
@onready var pause_menu_script = get_parent()



func _on_volume_pressed() -> void:
	# When volume button is pressed, the current scene changes to the volume UI.
	
	get_tree().change_scene_to_file("res://Scenes/Testing/Ground Zero - Raymond/Volume_UI.tscn")


func _on_back_pressed() -> void:
	visible = false
	pause_menu_script.pause_menu.visible = true
	


func _on_resolution_pressed() -> void:
# When resolution button is pressed, the current scene changes to the screen resolution.
	
	get_tree().change_scene_to_file("res://Scenes/Testing/Ground Zero - Raymond/Screen_Resolution.tscn")
