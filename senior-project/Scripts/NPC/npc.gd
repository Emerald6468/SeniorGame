class_name NPC
extends MeshInstance3D

@onready var talking_zone: Area3D = $TalkingZone

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player = get_parent().get_node("Player")
	if talking_zone.has_overlapping_bodies(): player.npc = self

func dialogue():
	print("hello my name is " + str(self.name))
