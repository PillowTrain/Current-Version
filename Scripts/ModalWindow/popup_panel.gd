extends PopupPanel

func _ready():
	hide()
	
func open_modal():
	#вікно відкриватиметься на таких кордах
	popup(Rect2(0, 0, 600, 1080))
