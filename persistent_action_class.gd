extends Node

class_name Persistent_action_class




var duration_in_turns := 3  # кількість ходів, протягом яких діє карта
var current_turn := 0
var is_active := false

func activate():
	print("Карта активована")
	is_active = true
	current_turn = 0
	start_effect()

func process_turn():
	if not is_active:
		return

	current_turn += 1
	if current_turn >= duration_in_turns:
		deactivate()

func deactivate():
	print("Карта деактивована")
	is_active = false
	stop_effect()
	queue_free()  # або залишити на столі, але вимкнути дію

func start_effect():
	print("Ефект почався")
	# Наприклад: підвищити захист гравця
	# player.defense += 1

func stop_effect():
	print("Ефект завершено")
	# Наприклад: зменшити захист
	# player.defense -= 1
