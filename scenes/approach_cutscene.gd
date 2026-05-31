extends Control

signal finished

@export var walk_fps: float = 8.0
@export var sheet_cols: int = 4
@export var sheet_rows: int = 4
@export var sheet_row_index: int = 3

class CityBackdrop:
	extends Control
	var phase := 0.0
	var seed_value := 1

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _hash_u32(v: int) -> int:
		var x: int = v
		x = int((x ^ (x >> 16)) * 0x7feb352d) & 0x7fffffff
		x = int((x ^ (x >> 15)) * 0x846ca68b) & 0x7fffffff
		x = int(x ^ (x >> 16)) & 0x7fffffff
		return x

	func _hash01(v: int) -> float:
		return float(_hash_u32(v)) / float(0x7fffffff)

	func _draw_moon(cx: float, cy: float, r: float, px: float, color: Color) -> void:
		var grid_r := int(ceil(r / px))
		for y in range(-grid_r, grid_r + 1):
			for x in range(-grid_r, grid_r + 1):
				var dx := float(x) * px
				var dy := float(y) * px
				if dx * dx + dy * dy <= r * r:
					draw_rect(Rect2(Vector2(cx + dx - px * 0.5, cy + dy - px * 0.5), Vector2(px, px)), color)

	func _draw() -> void:
		var px: float = 4.0
		var w: float = size.x
		var h: float = size.y
		var drift: float = sin(phase * 0.15) * 12.0

		var moon_cx: float = w * 0.80 + drift * 0.2
		var moon_cy: float = h * 0.18
		var moon_r: float = minf(w, h) * 0.07
		draw_line(Vector2(moon_cx, 0), Vector2(moon_cx, moon_cy - moon_r - 6.0), Color(0.75, 0.8, 1.0, 0.18), 2.0)
		_draw_moon(moon_cx, moon_cy, moon_r * 1.6, px, Color(0.95, 0.98, 1.0, 0.06))
		_draw_moon(moon_cx, moon_cy, moon_r * 1.15, px, Color(0.95, 0.98, 1.0, 0.10))
		_draw_moon(moon_cx, moon_cy, moon_r, px, Color(0.98, 0.98, 0.92, 0.95))
		_draw_moon(moon_cx + px, moon_cy - px, moon_r * 0.55, px, Color(0.92, 0.94, 0.86, 0.55))

		var star_count: int = 90
		for i in range(star_count):
			var fx: float = _hash01(seed_value + i * 31)
			var fy: float = _hash01(seed_value + i * 57)
			var sx: float = fx * w
			var sy: float = fy * (h * 0.45)
			var tw: float = 0.55 + 0.45 * sin(phase * (1.5 + fx * 3.0) + fy * TAU)
			var a: float = 0.10 + tw * 0.22
			var s: float = px * (1.0 if _hash01(seed_value + i * 91) > 0.7 else 0.5)
			draw_rect(Rect2(Vector2(sx - s * 0.5, sy - s * 0.5), Vector2(s, s)), Color(0.92, 0.96, 1.0, a))

		var base_y: float = h * 0.52
		var x: float = -60.0 + drift
		var b: int = 0
		while x < w + 60.0:
			var bw: float = 40.0 + floor(_hash01(seed_value + b * 77) * 90.0)
			var bh: float = 80.0 + floor(_hash01(seed_value + b * 97) * 220.0)
			var c: Color = Color(0.06, 0.07, 0.14, 1.0)
			if b % 3 == 1:
				c = Color(0.05, 0.06, 0.12, 1.0)
			elif b % 3 == 2:
				c = Color(0.07, 0.08, 0.16, 1.0)
			draw_rect(Rect2(Vector2(x, base_y - bh), Vector2(bw, bh)), c)

			var wx0: float = x + 8.0
			var wy0: float = base_y - bh + 10.0
			var wx_step: float = 10.0
			var wy_step: float = 12.0
			var cols: int = int(floor((bw - 16.0) / wx_step))
			var rows: int = int(floor((bh - 20.0) / wy_step))
			for yy in range(rows):
				for xx in range(cols):
					var id: int = seed_value ^ (b * 131 + xx * 17 + yy * 23)
					var on: bool = _hash01(id) > 0.62
					if on:
						var flick: float = 0.35 + 0.65 * (0.5 + 0.5 * sin(phase * (2.0 + float(xx) * 0.3) + float(yy) * 0.6 + float(b)))
						var col: Color = Color(0.98, 0.92, 0.52, 0.18 + 0.22 * flick)
						draw_rect(Rect2(Vector2(wx0 + float(xx) * wx_step, wy0 + float(yy) * wy_step), Vector2(px, px)), col)

			x += bw + 14.0
			b += 1

@onready var portrait_rect: TextureRect = $Portrait
@onready var shop_name_label: Label = $TitlePanel/Box/ShopName
@onready var subtitle_label: Label = $TitlePanel/Box/Subtitle
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var background_rect: ColorRect = $Background

var walk_sheet: Texture2D
var portrait_texture: Texture2D
var phase := 0.0
var is_boss := false
var character_rects: Array[TextureRect] = []
var character_sheets: Array[Texture2D] = []
var customer_name := ""
var customer_role := ""
var rng := RandomNumberGenerator.new()
var _walk_sheet_pool_cache: Array[Texture2D] = []
var city_backdrop: CityBackdrop

func setup(walk_sheet_texture: Texture2D, portrait_tex: Texture2D, name_text: String, role_text: String, boss: bool) -> void:
	walk_sheet = walk_sheet_texture
	self.portrait_texture = portrait_tex
	is_boss = boss
	self.customer_name = name_text
	self.customer_role = role_text

func _ready() -> void:
	rng.randomize()
	if is_instance_valid(background_rect):
		background_rect.color = Color(0.06, 0.06, 0.12, 1.0)
		if not is_instance_valid(city_backdrop):
			city_backdrop = CityBackdrop.new()
			city_backdrop.name = "CityBackdrop"
			city_backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
			city_backdrop.seed_value = rng.randi()
			background_rect.add_child(city_backdrop)
			background_rect.move_child(city_backdrop, 0)
	character_rects.clear()
	character_sheets.clear()
	for n in ["Character", "Character2", "Character3", "Character4", "Character5"]:
		if not has_node(NodePath(n)):
			continue
		var node := get_node(NodePath(n))
		if node is TextureRect:
			var rect := node as TextureRect
			rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			character_rects.append(rect)
	_apply_setup()
	_randomize_queue_hair()
	if is_instance_valid(animation_player):
		animation_player.animation_finished.connect(_on_animation_finished)
		animation_player.play("approach")

func _process(delta: float) -> void:
	phase += delta
	if is_instance_valid(city_backdrop):
		city_backdrop.phase = phase
		city_backdrop.queue_redraw()
	_update_character_frame()
	_update_title_effect()
	_update_queue_positions(delta)

func _update_title_effect() -> void:
	if not is_instance_valid(shop_name_label):
		return
	if is_boss:
		var a: float = 0.75 + 0.25 * sin(phase * 6.0)
		shop_name_label.modulate = Color(1, 1, 1, a)
	else:
		var a: float = 0.9 + 0.1 * sin(phase * 3.0)
		shop_name_label.modulate = Color(1, 1, 1, a)

func _update_character_frame() -> void:
	if character_rects.is_empty():
		return
	if not (walk_sheet is Texture2D):
		return
	for i in range(character_rects.size()):
		var rect := character_rects[i]
		var sheet: Texture2D = walk_sheet
		if i < character_sheets.size():
			sheet = character_sheets[i]
		var fw: int = int(floor(float(sheet.get_width()) / float(sheet_cols)))
		var fh: int = int(floor(float(sheet.get_height()) / float(sheet_rows)))
		if fw <= 0 or fh <= 0:
			continue
		var p := phase + float(i) * 0.18
		var col: int = int(floor(p * walk_fps)) % sheet_cols
		var row: int = clampi(sheet_row_index, 0, sheet_rows - 1)
		var atlas := AtlasTexture.new()
		atlas.atlas = sheet
		atlas.region = Rect2i(col * fw, row * fh, fw, fh)
		rect.texture = atlas

func _update_queue_positions(delta: float) -> void:
	if character_rects.size() <= 1:
		return
	var lead := character_rects[0] as TextureRect
	for i in range(1, character_rects.size()):
		var rect := character_rects[i] as TextureRect
		var desired := lead.position - Vector2(60.0 * float(i), 0.0)
		var k := clampf(delta * (6.0 - float(i) * 0.8), 0.0, 1.0)
		rect.position = rect.position.lerp(desired, k)
		rect.modulate = Color(1, 1, 1, 1.0 - float(i) * 0.12)

func _on_animation_finished(anim_name: StringName) -> void:
	if str(anim_name) == "approach":
		finished.emit()

func _apply_setup() -> void:
	if is_instance_valid(portrait_rect):
		portrait_rect.texture = portrait_texture
		portrait_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if is_instance_valid(shop_name_label):
		shop_name_label.text = customer_name
		shop_name_label.add_theme_font_size_override("font_size", 44)
		if is_boss:
			shop_name_label.add_theme_color_override("font_color", Color(1.0, 0.3, 0.3, 1.0))
		else:
			shop_name_label.add_theme_color_override("font_color", Color(1.0, 0.92, 0.3, 1.0))
	if is_instance_valid(subtitle_label):
		subtitle_label.text = customer_role if customer_role != "" else "深夜怪菜摊 · 正在接待"
		subtitle_label.add_theme_font_size_override("font_size", 18)
		subtitle_label.add_theme_color_override("font_color", Color(0.92, 0.95, 1.0, 0.82))

func _walk_sheet_pool() -> Array[Texture2D]:
	if not _walk_sheet_pool_cache.is_empty():
		return _walk_sheet_pool_cache
	var pool: Array[Texture2D] = []
	if walk_sheet is Texture2D:
		pool.append(walk_sheet)
	for path in [
		"res://assets/characters/pixel_character_1/Walking/Blue_Head_Walking-Sheet.png",
		"res://assets/characters/pixel_character_1/Walking/Orange_Head_Walking-Sheet.png",
		"res://assets/characters/pixel_character_1/Walking/Pink_Head_Walking-Sheet.png"
	]:
		var tex := load(path)
		if tex is Texture2D:
			pool.append(tex as Texture2D)
	_walk_sheet_pool_cache = pool
	return _walk_sheet_pool_cache

func _randomize_queue_hair() -> void:
	if character_rects.is_empty():
		return
	var pool := _walk_sheet_pool()
	if pool.is_empty():
		return
	character_sheets.clear()
	for _i in range(character_rects.size()):
		var pick: Texture2D = pool[rng.randi_range(0, pool.size() - 1)]
		character_sheets.append(pick)
