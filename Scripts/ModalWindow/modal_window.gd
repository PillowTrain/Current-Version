extends PopupPanel

func _ready():
	hide()
	
func open_modal():
	#вікно відкриватиметься на таких кордах
	popup(Rect2(1320, 0, 600, 1080))

func _on_Close_button_pressed():
	hide()
