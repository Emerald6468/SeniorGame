class_name NPC
extends MeshInstance3D

@onready var talking_zone: Area3D = $TalkingZone
var player
var chatbox
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_node("Player")
	chatbox = player.get_node("UI/CanvasLayer/Chatbox")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if talking_zone.has_overlapping_bodies(): player.npc = self

func dialogue():
	print("hello my name is " + str(self.name))
	if !Global.TextboxOpen:chatbox.set_to_ready()
	chatbox.add_text("hello my name is " + str(self.name)) 
