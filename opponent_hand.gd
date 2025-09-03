extends Node2D


@onready var action_box = $"../DeckEx"
@onready var deck = $"../Deck"


const CARD_WIDTH = 160
const HAND_Y_POSITION = 150
  # y-позиція опонента на екрані

var opponent_hand: Array = []
var center_screen_x: float
var label: Label

# Логіка прихованої карти
var has_hidden_card: bool = false
var hidden_card_node: Node2D = null
var hidden_card_value: int = 0


func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2
	label = $"../CardManager/Label2"
	update_score()

func update_score() -> void:
	var visible_total: int = 0
	for card in opponent_hand:
		visible_total += card.card_value

	if has_hidden_card:
		label.text = "? + %d / %d" % [visible_total, deck.win_score]
	else:
		label.text = "Score: %d" % visible_total
	
	var t = create_tween()
	t.tween_property(label, "scale", Vector2(1.2, 1.2), 0.15)
	t.tween_property(label, "scale", Vector2(1, 1), 0.15).set_delay(0.15)

func add_card_to_hand(card: Node2D, hidden: bool = false) -> void:
	if hidden and not has_hidden_card:
		has_hidden_card = true
		hidden_card_node = card
		hidden_card_value = card.card_value
		var sprite = card.get_node("Sprite2D")
		sprite.texture = load("res://Card[LOOP_DE_LOOP].png")
		sprite.visible = true
	else:
		opponent_hand.insert(0, card)

	update_hand_positions()
	update_score()


func animate_card_to_position(card: Node2D, target_position: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(card, "position", target_position, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	card.scale = Vector2(1.2, 1.2)
	tween.tween_property(card, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func update_hand_positions() -> void:
	for i in range(opponent_hand.size()):
		var card = opponent_hand[i]
		var idx = i + (1 if has_hidden_card else 0)
		var pos = Vector2(calculate_card_position(idx), HAND_Y_POSITION)
		animate_card_to_position(card, pos)
	if has_hidden_card and hidden_card_node:
		animate_card_to_position(hidden_card_node, Vector2(calculate_hidden_position(), HAND_Y_POSITION))

func calculate_card_position(index: int) -> float:
	var total_cards = opponent_hand.size() + (1 if has_hidden_card else 0)
	var total_width = (total_cards - 1) * CARD_WIDTH
	return center_screen_x + index * CARD_WIDTH - total_width / 2

func calculate_hidden_position() -> float:
	return calculate_card_position(0)

func reveal_hidden_card() -> void:
	if not has_hidden_card or hidden_card_node == null:
		return
	# Повертаємо справжню текстуру
	var sprite = hidden_card_node.get_node("Sprite2D")
	sprite.texture = load("res://EXPORTS[150x218]/"+ str(hidden_card_value) + ".png")
	# Додаємо до відкритих карт
	opponent_hand.insert(0, hidden_card_node)
	hidden_card_node = null
	has_hidden_card = false
	update_hand_positions()
	update_score()
	
func get_total_card_value() -> int:
	var total = 0
	for card in opponent_hand:
		total += card.card_value
	if has_hidden_card:
		total += hidden_card_value
	return total

func get_opponent_total() -> int:
	var total := 0
	for card in opponent_hand:
		total += card.card_value
	if has_hidden_card:
		total += hidden_card_value
	return total

func reset_hand():
	for card in opponent_hand:
		card.queue_free()
	opponent_hand.clear()

	if has_hidden_card and hidden_card_node:
		hidden_card_node.queue_free()
		hidden_card_node = null
		hidden_card_value = 0
		has_hidden_card = false

	update_score()
