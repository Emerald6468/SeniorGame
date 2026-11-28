extends Node3D

const HUB = preload("uid://diulqm3vqe1jy")
const ZONE_1_MANAGER = preload("uid://c5h83toc0iak4")




@export_node_path var CurrentZone
@export_enum("Hub", "Zone1", "Tutorial") var Destination: String

@onready var teleport_collision: Area3D = $TeleportCollision
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if teleport_collision.has_overlapping_bodies():
		var body_list = teleport_collision.get_overlapping_bodies()
		for body in body_list:
			if body is Player:
				teleport()

func teleport():
	match Destination:
		"Hub":
			pass
		"Zone1":
			var zone1 = ZONE_1_MANAGER.instantiate()
			get_node(CurrentZone).add_sibling(zone1)
			get_node(CurrentZone).queue_free()
		"Tutorial":
			pass
