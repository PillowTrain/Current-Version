extends Area2D

var settings_scene: PackedScene = preload("res://EXPORTS[150x218]/Settings.2.tscn")

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var settings_window = settings_scene.instantiate()
		get_tree().current_scene.add_child(settings_window)
		print("Відкрито вікно налаштувань")
