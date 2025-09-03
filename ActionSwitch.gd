extends Instant_action_class


var card_name: String = "ActionSwitch"
#створення змінної для присвоєння вузла
var deck: Node = null
var action: Node = null
var item_list: Node = null

func get_card_name() -> String:
	return card_name


func remove_random_items(item_list: ItemList, count: int):
	for i in range(count):
		var total = item_list.get_item_count()
		if total == 0:
			break  # Більше немає що видаляти
		var random_index = randi() % total
		item_list.remove_item(random_index)

func activate():
	print("Карта активована")
	remove_random_items(item_list, 2)
	for i in range(3):
		action._add_action_card()
	print("action_switch")
	
