extends Control

@onready var money_label = $Label
@onready var food_button = $HBoxContainer/Food
@onready var drug_button = $HBoxContainer/Drug
@onready var phamplet_button = $HBoxContainer/Phamplet
var money = 80

var shop_items = {
	"apple": 20,
	"meth": 70,
	"phamplet": 5
}

var items = shop_items.keys()




func _ready() -> void:
	money_label.text = "Money: $" + str(money)
	items.shuffle()
	update_buttons()
	food_button.text = items[0]
	drug_button.text = items[1]
	phamplet_button.text = items[2]
	
	

func update_buttons() -> void:
	food_button.disabled = money < shop_items[items[0]]
	drug_button.disabled = money < shop_items[items[1]]
	phamplet_button.disabled = money < shop_items[items[2]]

func _on_food_pressed() -> void:
	var item = items[0]
	var price = shop_items[item]
	
	if money >= price:
		money -= price
		money_label.text = "Money: $" + str(money)
		update_buttons()
	
	if money < 20:
		update_buttons()
	
	


func _on_drug_pressed() -> void:
	var item = items[1]
	var price = shop_items[item]
	
	if money >= price:
		money -= price
		money_label.text = "Money: $" + str(money)
		update_buttons()
	
	if money < 70:
		update_buttons()
	
	


func _on_phamplet_pressed() -> void:
	var item = items[2]
	var price = shop_items[item]
	
	if money >= price:
		money -= price
		money_label.text = "Money: $" + str(money)
		update_buttons()
	
	if money < 5:
		update_buttons()



func _on_button_pressed() -> void:
	money += 80
	money_label.text = "Money: $" + str(money)
	update_buttons()
