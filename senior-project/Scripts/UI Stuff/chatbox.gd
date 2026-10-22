extends Control

signal cutdone()

@onready var textbox_container = %Chatbox_Containter
@onready var label = %RichTextLabel
#@onready var button = %Button
@onready var portrait = %Sprite
#@onready var animation_tree = %portraitanimation_tree
#@onready var state_machine = animation_tree["parameters/playback"]

#@onready var character = %Character
var captain0 = ["Hello this is your captain speaking","We are happy to welcome you here on the U.N.S.table","You have been hired as the lets see here...","lead intern officer(in training)","Your pay will be 3 dogtreets per task completed" ]
var captain1 = ["First thing i want you to do is talk to meet the ship","it might feel a bit weird to move around at first->","(W or Right to go Right A or Left to go Left)","The gravity is pretty low here(Space to jump)","Now go on and make a good impression(E or enter to talk to crewmates)"]
#@onready var tween = get_tree().create_tween()

enum {
	READY,
	READING,
	FINISHED
}

#var test_array = ["hello","this is a test"]
var current = []
var on_switch = false
const CHAR_READ_RATE = .02
var state = READY
var time = 0.0
var mult_num = 0
var mult_switch = false
var character = 1
var cdone = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_textbox()
	state = READY
	#add_multiple(test_array)
	

func try_to_close():
	if state == FINISHED: 
		hide_textbox()

func set_to_ready():
	state = READY

func _process(delta: float) -> void:
	if on_switch:
		pass
		#runanimation(character)

func cuts():
	add_multiple(captain0)
	cdone = true
	
func hide_textbox():
	label.text = ""
	textbox_container.hide()
	on_switch = false
	Global.TextboxOpen = false

func show_textbox():
	textbox_container.show()
	Global.TextboxOpen = true
	on_switch = true
	
	
func add_text(next_text):
	if(state == READY):
		
		#texture = character
		var tween = get_tree().create_tween()
		state = READING
		time = len(next_text) * CHAR_READ_RATE
		label.visible_ratio = 0.0
		label.text = next_text
		show_textbox()
		tween.tween_property(label,"visible_ratio",1.0,time)
		print(label.visible_ratio)
		await get_tree().create_timer(time).timeout
		state = FINISHED
		print("test!")
		print(next_text)
	
func add_multiple(array):
	if mult_switch == false:
		mult_num = 0
	current = array
	mult_switch = true
	add_text(array[mult_num])
	if (mult_num+1) == array.size():
		mult_switch = false


func _on_button_pressed() -> void:
	print("test2")
	hide_textbox()
	state = READY
	mult_num += 1
	if mult_switch == true:
		add_multiple(current)
	else:
		if cdone == true:
			cutdone.emit()
			await get_tree().create_timer(.2).timeout
			add_multiple(captain1)
			cdone = false	
		
#func runanimation(character):
	##print(portrait.frame_coords)
	##print(state_machine.get_current_node())
	#if character == 0:
		#if state == READING:
			#state_machine.travel("captain_talking")
		#else:
			#state_machine.travel("captain_idle")
	#if character == 1:
		#if state == READING:
			#state_machine.travel("medic_talking")
			##print("test")
		#else:
			#state_machine.travel("medic_idle")
			##print("test2")
	#if character == 2:
		#if state == READING:
			#state_machine.travel("defense_talking")
		#else:
			#state_machine.travel("defense_idle")
	#if character == 3:
		#if state == READING:
			#state_machine.travel("farmer_talking")
		#else:
			#state_machine.travel("farmer_idle")
	#if character == 4:
		#if state == READING:
			#state_machine.travel("mechanic_talking")
		#else:
			#state_machine.travel("mechanic_idle")
		
	
	# Handles playing audio whenever somoene is speaking.
	#if state == READING:
		#if $Timer.time_left <= 0:
			#$AudioStreamPlayer2D.play()
			#$AudioStreamPlayer2D.pitch_scale = 0.5
			#$Timer.start(1)
	#if state == FINISHED:
		#print("I am here")
		#$AudioStreamPlayer2D.stop()
	#portrait.frame_coords = (character,1)
	
	
