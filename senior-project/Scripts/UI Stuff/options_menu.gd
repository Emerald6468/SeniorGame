extends Control

@onready var options_menu = $VBoxContainer
@onready var pause_menu_script = get_parent()
var volume_scene = load("res://Scenes/Testing/Ground Zero - Raymond/Volume_UI.tscn")
var resolution_scene = load("res://Scenes/Testing/Ground Zero - Raymond/Screen_Resolution.tscn")
var volume_instance = volume_scene.instantiate()
var resolution_instance = resolution_scene.instantiate()




func _on_volume_pressed() -> void:
	# When volume button is pressed, the current scene changes to the volume UI.
	add_child(volume_instance)
	options_menu.visible = false
	volume_instance.visible = true
	


func _on_back_pressed() -> void:
	visible = false
	pause_menu_script.pause_menu.visible = true
	


#func _on_resolution_pressed() -> void:
# When resolution button is pressed, the current scene changes to the screen resolution.
	#add_child(resolution_instance)
	#options_menu.visible = false
