extends ItemList


func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	#то просто виведення індекса
	print(index)
	#це ми так будемо отримувати назву функції
	print(get_item_text(index).replace(" ", "_"))
	#забирання ітема
	remove_item(index)
