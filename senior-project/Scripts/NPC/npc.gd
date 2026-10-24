class_name NPC
extends MeshInstance3D

#dialougue texts
var test_file = "res://Txt/Dialougue.txt"

@onready var talking_zone: Area3D = $TalkingZone
var player
var chatbox
var text_queue: Array[String]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_node("Player")
	chatbox = player.get_node("UI/CanvasLayer/Chatbox")
	if self.name == "kirk": 
		var test_array = get_text_array(test_file)
		text_queue =  Array(Array(test_array), TYPE_STRING, "", null )
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if talking_zone.has_overlapping_bodies(): player.npc = self

func add_to_queue(text):
	text_queue.append(text)

func get_text_array(res):
	var text_res = res
	var file = FileAccess.open(text_res,FileAccess.READ)
	var text = file.get_as_text()
	var text_array = text.split("\n")
	print(str(text_array))
	return text_array

func dialogue():
	#if !Global.TextboxOpen:chatbox.set_to_ready()
	if !text_queue.is_empty(): chatbox.add_text(text_queue[0]);text_queue.pop_front();print(str(text_queue))
