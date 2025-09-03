extends ItemList

@onready var action = $"../../../../../DeckEx"
@onready var card_slot = $"../../../../../CardSlot"
@onready var deck = $"../../../../../Deck"
@onready var item_list = self
@onready var player_hand = $"../../../../../PlayerHand"
@onready var card_manager = $"../../../../../CardManager"




func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	print(index)
	var item_text = get_item_text(index)
	print(item_text.replace(" ", "_"))

	var scene_path = "res://EXPORTS[150x218]/" + item_text.capitalize().replace(" ", "") + ".tscn"
	print(scene_path)
	
	var new_card = card_slot.add_card(scene_path)
	if new_card == null:
		print("Action deck is full")
		return
	
	remove_item(index)
	# Обробка Persistent карт (Go_for_*)
	if new_card is Persistent_action_class:
		# Спеціальна перевірка на Go_for_* по імені
		if new_card.name.begins_with("GoFor"):
			var to_remove := []
			for card in card_slot.card_instances:
				if card != null and card.name.begins_with("GoFor"):
					to_remove.append(card)

			for card in to_remove:
				card_slot.card_instances.erase(card)
				card.queue_free()

		if "deck" in new_card:
			new_card.deck = deck
		if "action" in new_card:
			new_card.action = action
		if "item_list" in new_card:
			new_card.item_list = item_list
		if "player_hand" in new_card:
			new_card.player_hand = player_hand
		if "card_manager" in new_card:
			new_card.card_manager = card_manager
		card_slot.card_instances.append(new_card)
		

		if new_card.has_method("activate"):
			new_card.activate()

		
		print(card_slot.card_instances)
		

	else:
		if new_card != null:
			if "deck" in new_card:
				new_card.deck = deck
			if "action" in new_card:
				new_card.action = action
			if "item_list" in new_card:
				new_card.item_list = item_list
			if "player_hand" in new_card:
				new_card.player_hand = player_hand
			if "card_manager" in new_card:
				new_card.card_manager = card_manager
			

			if new_card.has_method("activate"):
				new_card.activate()
				new_card.queue_free()
			
			
			
			
	
