extends PopupPanel

@onready var close_button: Button = $VBoxContainer/CloseButton

func _ready() -> void:
	popup_centered()


func _on_close_button_pressed() -> void:
	_save_settings()
	queue_free()

func _save_settings() -> void:
	# Тут твоя логіка збереження налаштувань
	pass
