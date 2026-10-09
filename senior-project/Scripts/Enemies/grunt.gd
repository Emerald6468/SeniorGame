extends Enemy

#this enemy is going to be grounded and be a quick fodder enemy that dies quickly
#only attack is melee

#attack
var just_attacked = false
var a_time = 1.0

func attack():
	if !just_attacked:
		just_attacked = true
		melee()
		await get_tree().create_timer(a_time).timeout
		just_attacked = false

func melee():
	print("melee")

func _physics_process(delta: float) -> void:
	super(delta)
	if close_enough: attack()
