extends Node2D

@onready var action_box = $"../DeckEx"
@onready var deck = $"../Deck"
const CARD_WIDTH = 160
const HAND_Y_POSITION = 929

var player_hand = []
var center_screen_x
var label: Label
var total: int = 0:
	set(new_total_value):
		total = new_total_value
		update_score()


func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2
	label = $"../CardManager/Label"
	update_score()

func update_score():
	var total = get_total_card_value()
	label.text = "%d/%d" % [total, deck.win_score]

	var t = create_tween()
	t.tween_property(label, "scale", Vector2(1.2, 1.2), 0.15)
	t.tween_property(label, "scale", Vector2(1, 1), 0.15).set_delay(0.15)
	

func add_card_to_hand(card):
	if card.name == "DeckEx":
		print("Цю сцену-карту не можна додати.")
		return
	
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_positions()
		update_score()
	else:
		animate_card_to_position(card, card.position)

func animate_card_to_position(card: Node2D, target_position: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(card, "position", target_position, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	card.scale = Vector2(1.2, 1.2)  
	tween.tween_property(card, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func update_hand_positions() -> void:
	for i in range(player_hand.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = player_hand[i]
		animate_card_to_position(card, new_position)  


func calculate_card_position(index) -> float:
	var total_width = (player_hand.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset


func get_total_card_value() -> int:
	var total = 0
	for card in player_hand:
		total += card.card_value
	return total

func reset_hand():
	for card in player_hand:
		card.queue_free()
	player_hand.clear()
	update_score()
