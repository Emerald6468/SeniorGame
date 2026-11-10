extends Node

func _ready() -> void:
	load_game()

func save():
	var save_dict = {
		"score" : 67,
		"username" : "Emerald",
		"position" : Vector3(0,0,0)
	}
	return save_dict

func save_game():
	var save_game = FileAccess.open("user://savezone.save", FileAccess.WRITE)
	
	var json_string = JSON.stringify(save())
	
	save_game.store_line(json_string)

func load_game():
	if not FileAccess.file_exists("user://savezone.save"):return
	
	var save_game = FileAccess.open("user://savezone.save",FileAccess.READ)
	
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		var node_data = json.get_data()
		
		print(node_data)
