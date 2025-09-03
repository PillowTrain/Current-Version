# ActionBox.gd
extends Node

# Змінні стану гри
var random_value
var bet: int = 1:
	set(new_value):
		bet = new_value
		_update_bet_label_text()
var win_score: int = 21:
	set(new_win_value):
		win_score = new_win_value
		_update_win_score_label_text()
var action_cards_hand = []



# Словник з картами за рідкістю
var Cards_by_rarity = {
	"Common": [
		"One_up", "Return", "Shield", "Love_your_enemy",
		"Forsed_draw", "Friendship", "Drunky_bet"
	],
	"Rare": [
		"Two_up", "Remove", "Go_for_11", "Go_for_18",
		"Go_for_24", "Go_for_28", "Shield+",
		"Confiscation", "Friendship+", "Go_against",
		"Bet_x_2", "Drunky_bet+", "Destroy"
	],
	"Ultra_rare": [
		"Exchange", "Action_switch", "Perfect_draw",
		"Harvest", "Steal", "Static_score"
	],
	"Mythic": [
		"Two_up+", "Action_switch+", "Destroy+",
		"Perfect_draw+", "Action_drop", "Action_drop+",
		"Banana", "Reload", "Abolition"
	],
	"Legendary": [
		"Destroy++", "Dream_card", "Dream_card+",
		"Ultimate_draw"
	]
}

# Вага рідкостей
var rarity_weights = {
	"Common": 50,
	"Rare": 25,
	"Ultra_rare": 15,
	"Mythic": 7,
	"Legendary": 3
}




@onready var action_box = self 
@onready var bet_label_node = $"../CardManager/Label6"
@onready var action_list = $"../ModalWindow/VBoxContainer/BoxContainer2/ScrollContainer/ItemList"
@onready var player_hand = $"../PlayerHand"

func _ready():
	randomize()
	
	



# Функція для оновлення тексту BetLabel
func _update_bet_label_text():
	if is_instance_valid(bet_label_node): # Використовуйте is_instance_valid для перевірки, чи нода дійсна
		bet_label_node.text = str(bet)

func _update_win_score_label_text():
	if is_instance_valid($"../CardManager/Label"): # Використовуйте is_instance_valid для перевірки, чи нода дійсна
		$"../CardManager/Label".text = str("%d/%d" % [player_hand.total, action_box.win_score])
	
		
		
# Випадковий вибір рідкості на основі ваги
func pick_weighted_rarity(weights: Dictionary) -> String:
	var total = 0
	for w in weights.values():
		total += w

	var rand = randi() % total
	var cumulative = 0

	for rarity in weights.keys():
		cumulative += weights[rarity]
		if rand < cumulative:
			return rarity
	return "Common"

var picked_rarity = pick_weighted_rarity(rarity_weights)
var card = Cards_by_rarity[picked_rarity].pick_random()






func _add_action_card():
	
	var picked_rarity = pick_weighted_rarity(rarity_weights)
	var card = Cards_by_rarity[picked_rarity].pick_random()
	#var card = "Bet_x_2"
	print(card)
	print('card')
	var card_name = card.to_lower()
	var icon_texture = load("res://" + card.replace("_", " ") + ".png")
		
	if icon_texture:
		action_list.add_item(card, icon_texture, true)
		action_list.queue_redraw()
	else:
		print(icon_texture)
		print("Не вдалося завантажити іконку для картки: ", card.replace("_", " ") + ".png")
	update_action_list()
	print("Випала карта:", card, "(", picked_rarity, ")")
	
	# action_box.call(card_name)


		
# Оновлення тексту з назвами карт
func update_action_list():
	var card_names = ""
	for card in action_cards_hand:
		card_names += "[url=%s]%s[/url]\n" % [card, card] # Генеруємо BBCode	



func random_1_2():
	randomize()
	random_value = 1 if randi() % 2 == 0 else 2
	return random_value

func one_up():
	bet += 1
	print("one_up")

func two_up():
	bet += 2
	print("two_up")

func go_for_11():
	win_score = 11
	print("go_for_11")

func go_for_18():
	win_score = 18
	print("go_for_18")

func go_for_24():
	win_score = 24
	print("go_for_24")

func go_for_28():
	win_score = 28
	print("go_for_28")

func shield():
	if bet >= 1:
		bet -= 1
	print("shield")

func shield_plus():
	if bet >= 2:
		bet -= 2
	print("shield_plus")

func drunky_bet():
	random_1_2()
	if random_value == 1:
		bet += 2
	if random_value == 2 && bet > 1:
		bet -= 2
	if random_value == 2 && bet <= 2:
		bet = 0
	print("drunky_bet")

func drunky_bet_plus():
	random_1_2()
	if random_value == 1:
		bet += 4
	if random_value == 2 && bet > 3:
		bet -= 4
	if random_value == 2 && bet <= 4:
		bet = 0
	print("drunky_bet_plus")

func bet_x_2():
	bet *= 2
	print("bet_x_2")

func action_drop():
	print("action_drop")

func action_drop_plus():
	print("action_drop_plus")

func two_up_plus(): # Функція для "Two_up+"
	bet += 4
	print("two_up_plus")

func action_switch():
	print("action_switch")

func perfect_draw():
	print("perfect_draw")

func harvest():
	print("harvest")

func steal():
	print("steal")

func static_score():
	print("static_score")

func action_switch_plus(): # Функція для "Action_switch+"
	print("action_switch_plus")

func destroy():
	print("destroy")

func perfect_draw_plus(): # Функція для "Perfect_draw+"
	print("perfect_draw_plus")

func banana():
	print("banana")

func reload():
	print("reload")

func abolition():
	print("abolition")

func destroy_plus():
	print("destroy_plus")

func destroy_plus_plus(): # Функція для "Destroy++"
	print("destroy_plus_plus")

func dream_card():
	print("dream_card")

func dream_card_plus(): # Функція для "Dream_card+"
	print("dream_card_plus")

func ultimate_draw():
	print("ultimate_draw")

func remove():
	print("remove")

func go_against():
	print("go_against")

func confiscation():
	print("confiscation")

func friendship():
	print("friendship")

func friendship_plus():
	print("friendship_plus")

func forsed_draw():
	print("forsed_draw")

func return_():
	print("return_")

func draw_1():
	print("draw_1")
	
func draw_2():
	print("draw_2")
	
func draw_3():
	print("draw_3")
	
func draw_4():
	print("draw_4")
	
func draw_5():
	print("draw_5")
	
func draw_6():
	print("draw_6")
	
func draw_7():
	print("draw_7")
	
func draw_8():
	print("draw_8")
	
func draw_9():
	print("draw_9")
	
func draw_10():
	print("draw_10")

func draw_11():
	print("draw_11")

func love_your_enemy():
	print("love_your_enemy")
