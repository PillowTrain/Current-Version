extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2

var screen_size: Vector2
var card_being_dragged: Node2D = null
var is_hovering_on_card: bool = false
var player_hand_reference
var label

func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_hand_reference = $"../PlayerHand"
	$"../InputManager".connect("left_mouse_button_released", on_left_click_released)
	player_hand_reference = $"../PlayerHand"
	label = $Label

func _process(_delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(
			clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y)
		)

func start_drag(card: Node2D) -> void:
	# Перетягування відключене — нічого не робимо
	return

func finish_drag() -> void:
	if card_being_dragged:
		card_being_dragged.scale = Vector2(1.05, 1.05)
		var card_slot_found = raycast_check_for_card_slot()
		if card_slot_found and not card_slot_found.card_in_slot:
			var global_pos = card_slot_found.global_position
			card_being_dragged.get_parent().remove_child(card_being_dragged)
			card_slot_found.add_child(card_being_dragged)
			card_being_dragged.global_position = global_pos

			card_being_dragged.position = Vector2.ZERO  # розмістити прямо в центрі слоту
			card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
			card_slot_found.card_in_slot = true
		else:
			player_hand_reference.add_card_to_hand(card_being_dragged)
			card_being_dragged.z_index = 2
		card_being_dragged = null


func connect_card_signals(card: Node) -> void:
	card.connect("hovered", Callable(self, "on_hovered_over_card"))
	card.connect("hovered_off", Callable(self, "on_hovered_over_off_card"))

func on_hovered_over_card(card: Node2D) -> void:
	if not is_hovering_on_card:
		is_hovering_on_card = true
	highlight_card(card, true)

func on_hovered_over_off_card(card: Node2D) -> void:
	highlight_card(card, false)
	var new_card_hovered = raycast_check_for_card()
	if new_card_hovered:
		highlight_card(new_card_hovered, true)
	else:
		is_hovering_on_card = false

func on_left_click_released():
	if card_being_dragged:
		finish_drag()

func highlight_card(card: Node2D, hovered: bool) -> void:
	if hovered:
		card.scale = Vector2(1.05, 1.05)
		card.z_index = 2
	else:
		card.scale = Vector2(1, 1)
		card.z_index = 1

func raycast_check_for_card() -> Node2D:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_card_with_highest_z_index(result)
	return null

func raycast_check_for_card_slot() -> Node:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

func get_card_with_highest_z_index(cards: Array) -> Node2D:
	var highest_z_card = cards[0].collider.get_parent() as Node2D
	var highest_z_index = highest_z_card.z_index
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent() as Node2D
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card
