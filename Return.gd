extends Instant_action_class


var card_name: String = "Return"
#створення змінної для присвоєння вузла
var deck: Node = null
var action: Node = null
var item_list: Node = null
var player_hand: Node = null
var card_manager: Node = null

func get_card_name() -> String:
	return card_name


func activate():
	print("Карта активована")
	if deck.all_used_numbers_cards.size() > 0:
		var last_number_card = deck.all_used_numbers_cards.pop_back()
		player_hand.player_hand.erase(last_number_card)
		card_manager.remove_child(last_number_card)
		deck.deck.append(deck.scene_path)
		print(deck.scene_path)
		print(deck.deck)
		
	else:
		print("No cards to return")
	
	print("action_switch")
