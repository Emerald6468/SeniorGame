extends HSlider

# Allows the audio bus name to be set in 
# the Inspector and stores it index.
@export
var bus_name: String

var bus_index: int

func _ready() -> void:
	# Gets the index of the audio bus and connects the 
	# slider's change signal to a function.
	
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	
	# Gets the current bus volume, converts it from decibals 
	# to a linear value, and assigns it to the slider.
	
	value = db_to_linear(
		AudioServer.get_bus_volume_db(bus_index)
	)

func _on_value_changed(value: float) -> void:
	# When the slider's value changes, convert it to decibels and 
	# apply the new volume to the selected audio bus.
	
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)
	
