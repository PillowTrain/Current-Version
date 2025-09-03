extends Instant_action_class


var card_name: String = "Betx2"
#створення змінної для присвоєння вузла
var deck: Node = null
var action: Node = null
var item_list: Node = null

func get_card_name() -> String:
	return card_name



func activate():
	print("Карта активована")
	deck.bet *= 2
	print("bet_x_2")
