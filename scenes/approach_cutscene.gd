extends Control

signal finished

@export var walk_fps: float = 8.0
@export var sheet_cols: int = 4
@export var sheet_rows: int = 4
@export var sheet_row_index: int = 0

@onready var portrait_rect: TextureRect = $Portrait
@onready var character_rect: TextureRect = $Character
@onready var shop_name_label: Label = $TitlePanel/Box/ShopName
@onready var subtitle_label: Label = $TitlePanel/Box/Subtitle
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var walk_sheet: Texture2D
var phase := 0.0
var is_boss := false

func setup(walk_sheet_texture: Texture2D, portrait_texture: Texture2D, customer_name: String, customer_role: String, boss: bool) -> void:
	walk_sheet = walk_sheet_texture
	is_boss = boss
	if is_instance_valid(portrait_rect):
		portrait_rect.texture = portrait_texture
		portrait_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if is_instance_valid(character_rect):
		character_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if is_instance_valid(shop_name_label):
		shop_name_label.text = "BOSS · " + customer_name if is_boss else customer_name
		shop_name_label.add_theme_font_size_override("font_size", 44)
		if is_boss:
			shop_name_label.add_theme_color_override("font_color", Color(1.0, 0.3, 0.3, 1.0))
		else:
			shop_name_label.add_theme_color_override("font_color", Color(1.0, 0.92, 0.3, 1.0))
	if is_instance_valid(subtitle_label):
		subtitle_label.text = customer_role if customer_role != "" else "深夜怪菜摊 · 正在接待"
		subtitle_label.add_theme_font_size_override("font_size", 18)
		subtitle_label.add_theme_color_override("font_color", Color(0.92, 0.95, 1.0, 0.82))

func _ready() -> void:
	if is_instance_valid(animation_player):
		animation_player.animation_finished.connect(_on_animation_finished)
		animation_player.play("approach")

func _process(delta: float) -> void:
	phase += delta
	_update_character_frame()
	_update_title_effect()

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
	if not is_instance_valid(character_rect):
		return
	if not (walk_sheet is Texture2D):
		return
	var fw: int = int(floor(float(walk_sheet.get_width()) / float(sheet_cols)))
	var fh: int = int(floor(float(walk_sheet.get_height()) / float(sheet_rows)))
	if fw <= 0 or fh <= 0:
		return
	var col: int = int(floor(phase * walk_fps)) % sheet_cols
	var row: int = clampi(sheet_row_index, 0, sheet_rows - 1)
	var atlas := AtlasTexture.new()
	atlas.atlas = walk_sheet
	atlas.region = Rect2i(col * fw, row * fh, fw, fh)
	character_rect.texture = atlas

func _on_animation_finished(anim_name: StringName) -> void:
	if str(anim_name) == "approach":
		finished.emit()
