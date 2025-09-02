extends Node2D

func _on_open_modal_button_pressed() -> void:
	var modal_window = $Cards/ModalWindow
	modal_window.open_modal()


func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	pass # Replace with function body.


func _on_close_button_pressed() -> void:
	$Cards/ModalWindow.hide()

func _ready() -> void:
	start_round()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func start_round():
	$Cards/Deck/NewRound.visible = false
	$Cards/Deck.draw_card_for_player()
	$Cards/Deck.draw_card_for_player()

	$Cards/Deck.draw_card_for_opponent()
	$Cards/Deck.draw_card_for_opponent(true)
