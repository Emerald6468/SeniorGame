extends Control

@onready var money_label = $Label
@onready var food_button = $HBoxContainer/Food
@onready var drug_button = $HBoxContainer/Drug
@onready var phamplet_button = $HBoxContainer/Phamplet
var money = 80


func _ready() -> void:
	money_label.text = "Money: $" + str(money)


func _on_food_pressed() -> void:
	if money >= 20:
		money -= 20
		money_label.text = "Money: $" + str(money)
	
	if money < 20:
		food_button.disabled = true
	
	


func _on_drug_pressed() -> void:
	
	if money >= 70:
		money -= 70
		money_label.text = "Money: $" + str(money)
	
	if money < 70:
		drug_button.disabled = true
	
	


func _on_phamplet_pressed() -> void:
	
	if money >= 5:
		money -= 5
		money_label.text = "Money: $" + str(money)
	
	if money < 5:
		phamplet_button.disabled = true
