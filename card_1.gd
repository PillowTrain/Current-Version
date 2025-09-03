extends Node2D
var card_value = 2
signal howered
signal howered_off

var starting_position 

func _ready() -> void:
	get_parent().connect_card_signals(self)
	
func _on_area_2d_mouse_entered() -> void:

		emit_signal("howered", self)

func _on_area_2d_mouse_exited() -> void:
		emit_signal("howered_off", self)
