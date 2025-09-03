extends Instant_action_class


var card_name: String = "DrunkyBet+"
#створення змінної для присвоєння вузла
var deck: Node = null
var action: Node = null
var item_list: Node = null
var random_value

func get_card_name() -> String:
	return card_name


func random_1_2():
	randomize()
	random_value = 1 if randi() % 2 == 0 else 2
	return random_value



func activate():
	print("Ефект почався")
	random_1_2()
	if random_value == 1:
		deck.bet += 4
	if random_value == 2 && deck.bet > 3:
		deck.bet -= 4
	if random_value == 2 && deck.bet <= 4:
		deck.bet = 0
	print("drunky_bet_plus")
