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

func setup(walk_sheet_texture: Texture2D, portrait_texture: Texture2D, shop_name: String, subtitle: String, _boss: bool) -> void:
	walk_sheet = walk_sheet_texture
	if is_instance_valid(portrait_rect):
		portrait_rect.texture = portrait_texture
		portrait_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if is_instance_valid(character_rect):
		character_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if is_instance_valid(shop_name_label) and shop_name != "":
		shop_name_label.text = shop_name
	if is_instance_valid(subtitle_label) and subtitle != "":
		subtitle_label.text = subtitle

func _ready() -> void:
	if is_instance_valid(animation_player):
		animation_player.animation_finished.connect(_on_animation_finished)
		animation_player.play("approach")

func _process(delta: float) -> void:
	phase += delta
	_update_character_frame()

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
