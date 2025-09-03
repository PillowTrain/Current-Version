extends Node2D

var slot_paths := [
	"res://Scenes/Slots/card_slot_img_1.tscn",
	"res://Scenes/Slots/card_slot_img_2.tscn",
	"res://Scenes/Slots/card_slot_img_12.tscn",
	"res://Scenes/Slots/card_slot_img_22.tscn",
	"res://Scenes/Slots/card_slot_img_25.tscn",
	"res://Scenes/Slots/card_slot_img_23.tscn",
	"res://Scenes/Slots/card_slot_img_13.tscn",
	"res://Scenes/Slots/card_slot_img_14.tscn",
	"res://Scenes/Slots/card_slot_img_15.tscn",
	"res://Scenes/Slots/card_slot_img_24.tscn",
	"res://Scenes/Slots/card_slot_img.tscn",
]

var slots := []

func _ready():
	for path in slot_paths:
		var slot_scene = load(path)
		if slot_scene:
			var slot_instance = slot_scene.instantiate()
			add_child(slot_instance)
			slots.append(slot_instance)
		else:
			print("Не вдалося завантажити слот за шляхом: ", path)

	#add_card("res://destroy.tscn")
	



func add_card(card_scene_path: String):
	var card_scene = load(card_scene_path)
	if not card_scene:
		print("Помилка: не вдалося завантажити сцену карти")
		return

	var card = card_scene.instantiate()

	for i in range(slots.size()):
		var container = slots[i].get_node("CardContainer")
		if container == null:
			print("У слота ", i, " немає CardContainer!")
			continue

		if container.get_child_count() == 0:
			container.add_child(card)
			card.position = Vector2.ZERO
			if card.has_method("get_card_name"):
				print("Карта додана в слот ", i, ": ", card.get_card_name())
			else:
				print("Карта без методу get_card_name")
			return

	print("Немає вільних слотів!")
