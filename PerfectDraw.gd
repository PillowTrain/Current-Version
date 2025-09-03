extends Instant_action_class


var card_name: String = "PerfectDraw"
#створення змінної для присвоєння вузла
var deck: Node = null
var action: Node = null
var item_list: Node = null
var remaining_cards = deck.deck

func get_card_name() -> String:
	return card_name



func activate():
	print("Карта активована")
	
	#while remaining_cards > 1:
		
	deck.bet *= 2
	print("bet_x_2")
