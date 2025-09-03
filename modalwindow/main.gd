extends Node2D

func _on_open_modal_button_pressed() -> void:
	var modal_window = $ModalWindow
	modal_window.open_modal()
