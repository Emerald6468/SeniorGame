
"""
Docs:
	- Parent character must have 'health' & 'max_health' properties
"""


extends TextureProgressBar

# The 3D character whose health this bar represents
@export var character: Node3D
# Camera to calculate screen-space position
var camera: Camera3D

func _ready():
	# Get the active camera
	camera = get_viewport().get_camera_3d()
	
	# Set the initial value to a placeholder (e.g., full health)
	if character and "max_health" in character:
		value = character.max_health
	if character and "health" in character:
		value = character.health

func _process(delta):
	if not character or not camera:
		return
	
	# Update health bar value
	if character and "health" in character:
		value = character.health
	# Convert the 3D character's global position to screen-space coordinates
	# with some Offset upward (e.g., above the character)
	#if character not on screen hide
	if camera.is_position_in_frustum(character.global_position):show()
	else:hide()
	var screen_pos = camera.unproject_position(character.global_position + Vector3(0, 2, 0))
	global_position = screen_pos
	#  you can adjust the position for visual clarity
	global_position += Vector2(-get_rect().size.x / 2, 0)
	# Adjust scale based on distance from camera
	var distance = camera.global_transform.origin.distance_to(character.global_transform.origin)
	var scale_factor = clamp(1.0 - distance / 15.0, .2, 1.0)
	scale = Vector2(scale_factor, scale_factor)
