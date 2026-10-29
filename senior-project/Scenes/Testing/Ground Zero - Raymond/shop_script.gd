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
func _ready() -> void:
	money_label.text = "Money: $" + str(money)
	update_buttons()
	

func update_buttons() -> void:
	food_button.disabled = money < 20
	drug_button.disabled = money < 70
	phamplet_button.disabled = money < 5

func _on_food_pressed() -> void:
	if money >= shop_items["apple"]:
		money -= shop_items["apple"]
		money_label.text = "Money: $" + str(money)
		update_buttons()
	
	if money < 20:
		update_buttons()
	
	


func _on_drug_pressed() -> void:
	
	if money >= shop_items["meth"]:
		money -= shop_items["meth"]
		money_label.text = "Money: $" + str(money)
		update_buttons()
	
	if money < 70:
		update_buttons()
	
	


func _on_phamplet_pressed() -> void:
	
	if money >= shop_items["phamplet"]:
		money -= shop_items["phamplet"]
		money_label.text = "Money: $" + str(money)
		update_buttons()
	
	if money < 5:
		update_buttons()



func _on_button_pressed() -> void:
	money += 80
	money_label.text = "Money: $" + str(money)
	update_buttons()
