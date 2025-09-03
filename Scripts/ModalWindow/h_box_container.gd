extends HBoxContainer

const SPRITE_COUNT := 10
const SPRITE_SIZE := Vector2(250, 364)
const SPACING := 20
const SPRITE_PATH := "res://Border[DASHED_FIXED].png"  # Замінити на актуальний шлях

func _ready():
	# Встановлення відступу між елементами
	add_theme_constant_override("separation", SPACING)

	# Центрування контейнера (лише якщо батьківський — Control)
	if owner is Control:
		anchor_left = 0.5
		anchor_right = 0.5
		anchor_top = 0.5
		anchor_bottom = 0.5
		offset_left = -((SPRITE_SIZE.x + SPACING) * SPRITE_COUNT) / 2.0
		offset_top = -SPRITE_SIZE.y / 2.0

	# Додавання спрайтів
	var sprite_texture = preload(SPRITE_PATH)

	for i in SPRITE_COUNT:
		var sprite = Sprite2D.new()
		sprite.texture = sprite_texture
		sprite.scale = SPRITE_SIZE / sprite_texture.get_size()
		add_child(sprite)
