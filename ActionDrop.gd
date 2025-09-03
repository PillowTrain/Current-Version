extends Persistent_action_class


var card_name: String = "actionDrop"
#створення змінної для присвоєння вузла
var deck: Node = null
var action: Node = null
var item_list: Node = null

func get_card_name() -> String:
	return card_name






func _ready():
	duration_in_turns = 2  # кількість ходів, протягом яких діє карта
	current_turn = 0
	is_active = false

func activate():
	print("Карта активована")
	is_active = true
	current_turn = 0
	start_effect()

func process_turn():
	if not is_active:
		return

	current_turn += 1
	if current_turn >= duration_in_turns:
		deactivate()

func deactivate():
	print("Карта деактивована")
	is_active = false
	stop_effect()
	queue_free()  
	
	
func start_effect():
	print("Ефект почався")
	action.rarity_weights["Common"] += 12
	action.rarity_weights["Rare"] -= 5
	action.rarity_weights["Ultra_rare"] -= 3
	action.rarity_weights["Mythic"] -= 3
	action.rarity_weights["Legendary"] -= 1
	print("action_drop")

func stop_effect():
	print("Ефект завершено")
	action.rarity_weights["Common"] -= 12
	action.rarity_weights["Rare"] += 5
	action.rarity_weights["Ultra_rare"] += 3
	action.rarity_weights["Mythic"] += 3
	action.rarity_weights["Legendary"] += 1
