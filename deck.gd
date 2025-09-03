extends Node2D

const ALL_CARD_PATHS = [
	"res://Cards1-11/Card1.tscn",
	"res://Cards1-11/Card2.tscn",
	"res://Cards1-11/Card3.tscn",
	"res://Cards1-11/Card4.tscn",
	"res://Cards1-11/Card5.tscn",
	"res://Cards1-11/Card6.tscn",
	"res://Cards1-11/Card7.tscn",
	"res://Cards1-11/Card8.tscn",
	"res://Cards1-11/Card9.tscn",
	"res://Cards1-11/Card10.tscn",
	"res://Cards1-11/Card11.tscn",
]


@onready var action_box = $"../DeckEx"
@onready var item_list = $"../ModalWindow/VBoxContainer/BoxContainer2/ScrollContainer/ItemList"
@onready var card_slot = $"../CardSlot"
@onready var bet_label_node = $"../CardManager/Label6"
@onready var player_hand = $"../PlayerHand"




var player_score: int = 5
var opponent_score: int = 5
var round_started := false
var player_stopped := false
var opponent_stopped := false
var player_passed := false
var opponent_passed := false
var round_over := false
var deck = []	
var opponent_draw_count: int = 0
var all_used_numbers_cards := []
var scene_path
var bet: int = 1:
	set(new_value):
		bet = new_value
		_update_bet_label_text()
var win_score: int = 21:
	set(new_win_value):
		win_score = new_win_value
		_update_win_score_label_text()

func _ready() -> void:
	randomize()
	deck = ALL_CARD_PATHS.duplicate()
	$Area2D.connect("input_event", _on_deck_clicked)


func _update_bet_label_text():
	if is_instance_valid(bet_label_node): # Використовуйте is_instance_valid для перевірки, чи нода дійсна
		bet_label_node.text = str(bet)
		
func _update_win_score_label_text():
	if is_instance_valid($"../CardManager/Label"): # Використовуйте is_instance_valid для перевірки, чи нода дійсна
		$"../CardManager/Label".text = str("%d/%d" % [player_hand.total, win_score])
		
		
func draw_card_for_player():
	if deck.is_empty():
		_disable_deck()
		return

	var card = draw_random_card()
	all_used_numbers_cards.append(card)
	if card == null:
		return

	$"../CardManager".add_child(card)
	card.position = Vector2(100, 500)
	$"../PlayerHand".add_card_to_hand(card)

	card.set_process_input(false)
	card.set_position(card.position)
	var collision_shape = card.get_node("Area2D/CollisionShape2D")
	if collision_shape:
		collision_shape.disabled = true

func draw_card_for_opponent(hidden := false):
	var opponent_hand = $"../OpponentHand".opponent_hand
	if opponent_hand.size() >= 8:
		return

	if deck.is_empty():
		print("Deck is empty.")
		return

	var index = randi() % deck.size()
	var scene_path = deck[index]
	print(scene_path)
	deck.remove_at(index)

	var card_scene = load(scene_path)
	var new_card = card_scene.instantiate()
	new_card.name = "OpponentCard"

	$"../CardManager".add_child(new_card)

	new_card.position = Vector2(100, 100) 

	$"../OpponentHand".add_card_to_hand(new_card, hidden)

	new_card.set_process_input(false)

	var collision_shape = new_card.get_node("Area2D/CollisionShape2D")
	if collision_shape:
		collision_shape.disabled = true



func draw_random_card() -> Node2D:
	if deck.is_empty():
		return null

	var index = randi() % deck.size()
	scene_path = deck[index]
	deck.remove_at(index)

	var card_scene = load(scene_path)
	var new_card = card_scene.instantiate()
	new_card.name = "Card"
	return new_card

func _disable_deck():
	print("Deck is empty.")
	$Area2D.set_deferred("disabled", true)
	$Sprite2D.visible = false

func action_process():
	if card_slot.card_instances.is_empty():
		return
	
	# Очистити список від звільнених карт
	card_slot.card_instances = card_slot.card_instances.filter(func(c): return is_instance_valid(c))
	
	for card in card_slot.card_instances:
		if card.has_method("process_turn"):
			card.process_turn()

var round = 1

func _on_deck_clicked(viewport, event, shape_idx):
	if round_over:
		return

	if event is InputEventMouseButton and event.pressed:
		var player_total = $"../PlayerHand".get_total_card_value()

		if event.button_index == MOUSE_BUTTON_LEFT:
			if not player_passed and player_total <= win_score:
				draw_card_for_player()
				$"../DeckEx"._add_action_card()
				round += 1
				
				print("round: %d" % round)
				opponent_turn()

		elif event.button_index == MOUSE_BUTTON_RIGHT:
			player_passed = true
			opponent_turn()
			check_round_end()

func opponent_turn():
	if opponent_passed:
		check_round_end()
		return

	var total = $"../OpponentHand".get_opponent_total()
	
	if total >= win_score:
		opponent_passed = true
	else:
		var chance_to_draw = 1.0  


		match total:
			17:
				chance_to_draw = 0.5
			18:
				chance_to_draw = 0.3
			19:
				chance_to_draw = 0.15
			20:
				chance_to_draw = 0.05
			_:
				chance_to_draw = 1.0  

		if randf() < chance_to_draw:
			draw_card_for_opponent()
		else:
			opponent_passed = true

	check_round_end()


func check_round_end():
	if player_passed and opponent_passed and not round_over:
		round_over = true
		show_result()


func show_result():
	$"../OpponentHand".reveal_hidden_card()
	var player_total = $"../PlayerHand".get_total_card_value()
	var opponent_total = $"../OpponentHand".get_opponent_total()

	var winner = ""

	if player_total > win_score and opponent_total > win_score:
		if abs(win_score - player_total) < abs(win_score - opponent_total):
			winner = "Player wins"
			player_score -= bet
			opponent_score += bet
		elif abs(win_score - player_total) > abs(win_score - opponent_total):
			winner = "Opponent wins"
			opponent_score -= bet
			player_score += bet
		else:
			winner = "Draw"
	elif player_total <= win_score and opponent_total > win_score:
		winner = "Player wins"
		player_score -= bet
		opponent_score += bet
	elif opponent_total <= win_score and player_total > win_score:
		winner = "Opponent wins"
		opponent_score -= bet
		player_score += bet
	elif player_total <= win_score and opponent_total <= win_score:
		if player_total > opponent_total:
			winner = "Player wins"
			player_score -= bet
			opponent_score += bet
		elif player_total < opponent_total:
			winner = "Opponent wins"
			opponent_score -= bet
			player_score += bet
		else:
			winner = "Draw"

	$"../CardManager/Label3".text += "\n" + winner
	$NewRound.visible = true
	




func _on_new_round_pressed() -> void:
	if round_over:
		action_process()
		round = 1
		bet += 1
		round_over = false
		player_passed = false
		opponent_passed = false
		player_stopped = false
		opponent_stopped = false

		$"../PlayerHand".reset_hand()
		$"../OpponentHand".reset_hand()
		$"../CardManager/Label3".text = ""

		deck = ALL_CARD_PATHS.duplicate()
		$Area2D.set_deferred("disabled", false)
		$Sprite2D.visible = true
		$"../CardManager/Label4".text = "Score: %d" % opponent_score
		$"../CardManager/Label5".text = "Score: %d" % player_score
		$"../CardManager/Label6".text = "Bet: %d" % bet
		$"../..".start_round()

func clear_cards():
	for child in get_children():
		child.queue_free()
