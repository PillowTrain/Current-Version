extends RichTextLabel

@onready var action_box = get_node("res://Scenes/Game/deck_ex.tscn")




func _ready():
 bbcode_enabled = true
 connect("meta_clicked", Callable(self, "_on_meta_clicked"))
 text = ""

func _on_meta_clicked(meta):
 var card_name = meta as String
 var method_name = card_name.to_lower().replace("+", "_plus").replace("++", "_plus_plus").replace(" ", "_")
 if action_box.has_method(method_name):
  action_box.call(method_name)
  print("Виклик функції:", method_name)
 else:
  print("Функція для", card_name, "не знайдена")
