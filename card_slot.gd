extends Node2D

var slot_paths := [
	"res://card_slot_img_1.tscn",
	"res://card_slot_img_2.tscn",
	"res://card_slot_img_3.tscn",
	"res://card_slot_img_4.tscn",
	"res://card_slot_img_5.tscn",
	"res://card_slot_img_6.tscn",
	"res://card_slot_img_7.tscn",
	"res://card_slot_img_8.tscn",
	"res://card_slot_img_9.tscn",
	"res://card_slot_img_10.tscn",
]

var slots := []
var card_instances: Array = []


func _ready():
	for path in slot_paths:
		var slot_scene = load(path)
		if slot_scene:
			var slot_instance = slot_scene.instantiate()
			add_child(slot_instance)
			slots.append(slot_instance)
		else:
			print("Не вдалося завантажити слот за шляхом: ", path)




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
			return card
	
	$"../CardManager/Label7".visible = true
	print("Немає вільних слотів!")
	return null
	
