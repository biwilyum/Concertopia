@tool
extends EditorScript

func _run() -> void:
	_write_tscn()
	_write_gd()
	print("HOME FILES WRITTEN OK")

func _write_tscn() -> void:
	var tscn : String = """[gd_scene load_steps=4 format=3 uid="uid://home_scene"]

[ext_resource type="Script" path="res://scripts/home.gd" id="1_home"]

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_enter"]
bg_color = Color(0.96, 0.57, 0.72, 1)
corner_radius_top_left = 23
corner_radius_top_right = 23
corner_radius_bottom_right = 23
corner_radius_bottom_left = 23
content_margin_left = 24.0
content_margin_top = 10.0
content_margin_right = 24.0
content_margin_bottom = 10.0

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_enter_hover"]
bg_color = Color(1.0, 0.70, 0.82, 1)
corner_radius_top_left = 23
corner_radius_top_right = 23
corner_radius_bottom_right = 23
corner_radius_bottom_left = 23
content_margin_left = 24.0
content_margin_top = 10.0
content_margin_right = 24.0
content_margin_bottom = 10.0

[node name="Home" type="Control"]
script = ExtResource("1_home")
anchor_right = 1.0
anchor_bottom = 1.0
offset_left = 0.0
offset_top = 0.0
offset_right = 0.0
offset_bottom = 0.0
grow_horizontal = 2
grow_vertical = 2

[node name="BgColor" type="ColorRect" parent="."]
anchor_right = 1.0
anchor_bottom = 1.0
offset_left = 0.0
offset_top = 0.0
offset_right = 0.0
offset_bottom = 0.0
grow_horizontal = 2
grow_vertical = 2
color = Color(0.04, 0.02, 0.10, 1)
mouse_filter = 2

[node name="BgTexture" type="TextureRect" parent="."]
anchor_right = 1.0
anchor_bottom = 1.0
offset_left = 0.0
offset_top = 0.0
offset_right = 0.0
offset_bottom = 0.0
grow_horizontal = 2
grow_vertical = 2
stretch_mode = 6
expand_mode = 1
mouse_filter = 2

[node name="BgTint" type="ColorRect" parent="."]
anchor_right = 1.0
anchor_bottom = 1.0
offset_left = 0.0
offset_top = 0.0
offset_right = 0.0
offset_bottom = 0.0
grow_horizontal = 2
grow_vertical = 2
color = Color(0.0, 0.0, 0.0, 0.45)
mouse_filter = 2

[node name="TopBar" type="MarginContainer" parent="."]
anchor_right = 1.0
anchor_bottom = 0.0
offset_left = 0.0
offset_top = 0.0
offset_right = 0.0
offset_bottom = 56.0
grow_horizontal = 2
theme_override_constants/margin_left = 16
theme_override_constants/margin_right = 16
theme_override_constants/margin_top = 8
theme_override_constants/margin_bottom = 8
mouse_filter = 2

[node name="TopHBox" type="HBoxContainer" parent="TopBar"]
anchor_right = 1.0
anchor_bottom = 1.0
mouse_filter = 2

[node name="BtnBack" type="Button" parent="TopBar/TopHBox"]
custom_minimum_size = Vector2(90, 36)
text = "< Back"
flat = true
size_flags_horizontal = 0

[node name="TopSpacer" type="Control" parent="TopBar/TopHBox"]
size_flags_horizontal = 3
mouse_filter = 2

[node name="MainMargin" type="MarginContainer" parent="."]
anchor_right = 1.0
anchor_bottom = 1.0
offset_left = 0.0
offset_top = 56.0
offset_right = 0.0
offset_bottom = 0.0
grow_horizontal = 2
grow_vertical = 2
theme_override_constants/margin_left = 0
theme_override_constants/margin_right = 0
theme_override_constants/margin_top = 16
theme_override_constants/margin_bottom = 24
mouse_filter = 2

[node name="MainVBox" type="VBoxContainer" parent="MainMargin"]
anchor_right = 1.0
anchor_bottom = 1.0
theme_override_constants/separation = 24
mouse_filter = 2

[node name="LabelTitle" type="Label" parent="MainMargin/MainVBox"]
custom_minimum_size = Vector2(0, 48)
size_flags_horizontal = 3
horizontal_alignment = 1
theme_override_font_sizes/font_size = 22
text = "Choose Artist's Concert Room"
mouse_filter = 2

[node name="CarouselStage" type="Control" parent="MainMargin/MainVBox"]
clip_contents = true
custom_minimum_size = Vector2(0, 200)
size_flags_horizontal = 3
size_flags_vertical = 3
mouse_filter = 2

[node name="CardRow" type="Control" parent="MainMargin/MainVBox/CarouselStage"]
mouse_filter = 2

[node name="Slot_BrunoMars" type="Control" parent="MainMargin/MainVBox/CarouselStage/CardRow"]
mouse_filter = 2

[node name="Card" type="PanelContainer" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_BrunoMars"]
custom_minimum_size = Vector2(280, 160)

[node name="CardHBox" type="HBoxContainer" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_BrunoMars/Card"]
anchor_right = 1.0
anchor_bottom = 1.0
theme_override_constants/separation = 0
mouse_filter = 2

[node name="DoorPanel" type="Control" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_BrunoMars/Card/CardHBox"]
custom_minimum_size = Vector2(70, 0)
size_flags_vertical = 3
mouse_filter = 2

[node name="RightArea" type="Control" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_BrunoMars/Card/CardHBox"]
size_flags_horizontal = 3
size_flags_vertical = 3
mouse_filter = 2

[node name="BokehBg" type="ColorRect" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_BrunoMars/Card/CardHBox/RightArea"]
anchor_right = 1.0
anchor_bottom = 1.0
mouse_filter = 2

[node name="CrowdBadge" type="PanelContainer" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_BrunoMars/Card/CardHBox/RightArea"]
offset_left = 8.0
offset_top = 8.0
offset_right = 80.0
offset_bottom = 32.0

[node name="BadgeHBox" type="HBoxContainer" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_BrunoMars/Card/CardHBox/RightArea/CrowdBadge"]
theme_override_constants/separation = 4
mouse_filter = 2

[node name="LabelIcon" type="Label" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_BrunoMars/Card/CardHBox/RightArea/CrowdBadge/BadgeHBox"]
theme_override_font_sizes/font_size = 11
text = "people"
mouse_filter = 2

[node name="LabelCrowd" type="Label" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_BrunoMars/Card/CardHBox/RightArea/CrowdBadge/BadgeHBox"]
theme_override_font_sizes/font_size = 11
theme_override_colors/font_color = Color(1, 1, 1, 1)
mouse_filter = 2

[node name="LabelArtist" type="Label" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_BrunoMars/Card/CardHBox/RightArea"]
anchor_right = 1.0
anchor_bottom = 1.0
offset_left = 12.0
offset_right = -72.0
vertical_alignment = 1
theme_override_font_sizes/font_size = 22
theme_override_colors/font_color = Color(1, 1, 1, 1)
mouse_filter = 2

[node name="Slot_TaylorSwift" type="Control" parent="MainMargin/MainVBox/CarouselStage/CardRow"]
mouse_filter = 2

[node name="Card" type="PanelContainer" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_TaylorSwift"]
custom_minimum_size = Vector2(280, 160)

[node name="CardHBox" type="HBoxContainer" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_TaylorSwift/Card"]
anchor_right = 1.0
anchor_bottom = 1.0
theme_override_constants/separation = 0
mouse_filter = 2

[node name="DoorPanel" type="Control" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_TaylorSwift/Card/CardHBox"]
custom_minimum_size = Vector2(70, 0)
size_flags_vertical = 3
mouse_filter = 2

[node name="RightArea" type="Control" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_TaylorSwift/Card/CardHBox"]
size_flags_horizontal = 3
size_flags_vertical = 3
mouse_filter = 2

[node name="BokehBg" type="ColorRect" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_TaylorSwift/Card/CardHBox/RightArea"]
anchor_right = 1.0
anchor_bottom = 1.0
mouse_filter = 2

[node name="CrowdBadge" type="PanelContainer" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_TaylorSwift/Card/CardHBox/RightArea"]
offset_left = 8.0
offset_top = 8.0
offset_right = 80.0
offset_bottom = 32.0

[node name="BadgeHBox" type="HBoxContainer" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_TaylorSwift/Card/CardHBox/RightArea/CrowdBadge"]
theme_override_constants/separation = 4
mouse_filter = 2

[node name="LabelIcon" type="Label" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_TaylorSwift/Card/CardHBox/RightArea/CrowdBadge/BadgeHBox"]
theme_override_font_sizes/font_size = 11
text = "people"
mouse_filter = 2

[node name="LabelCrowd" type="Label" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_TaylorSwift/Card/CardHBox/RightArea/CrowdBadge/BadgeHBox"]
theme_override_font_sizes/font_size = 11
theme_override_colors/font_color = Color(1, 1, 1, 1)
mouse_filter = 2

[node name="LabelArtist" type="Label" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_TaylorSwift/Card/CardHBox/RightArea"]
anchor_right = 1.0
anchor_bottom = 1.0
offset_left = 12.0
offset_right = -72.0
vertical_alignment = 1
theme_override_font_sizes/font_size = 22
theme_override_colors/font_color = Color(1, 1, 1, 1)
mouse_filter = 2

[node name="Slot_ArianaGrande" type="Control" parent="MainMargin/MainVBox/CarouselStage/CardRow"]
mouse_filter = 2

[node name="Card" type="PanelContainer" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_ArianaGrande"]
custom_minimum_size = Vector2(280, 160)

[node name="CardHBox" type="HBoxContainer" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_ArianaGrande/Card"]
anchor_right = 1.0
anchor_bottom = 1.0
theme_override_constants/separation = 0
mouse_filter = 2

[node name="DoorPanel" type="Control" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_ArianaGrande/Card/CardHBox"]
custom_minimum_size = Vector2(70, 0)
size_flags_vertical = 3
mouse_filter = 2

[node name="RightArea" type="Control" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_ArianaGrande/Card/CardHBox"]
size_flags_horizontal = 3
size_flags_vertical = 3
mouse_filter = 2

[node name="BokehBg" type="ColorRect" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_ArianaGrande/Card/CardHBox/RightArea"]
anchor_right = 1.0
anchor_bottom = 1.0
mouse_filter = 2

[node name="CrowdBadge" type="PanelContainer" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_ArianaGrande/Card/CardHBox/RightArea"]
offset_left = 8.0
offset_top = 8.0
offset_right = 80.0
offset_bottom = 32.0

[node name="BadgeHBox" type="HBoxContainer" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_ArianaGrande/Card/CardHBox/RightArea/CrowdBadge"]
theme_override_constants/separation = 4
mouse_filter = 2

[node name="LabelIcon" type="Label" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_ArianaGrande/Card/CardHBox/RightArea/CrowdBadge/BadgeHBox"]
theme_override_font_sizes/font_size = 11
text = "people"
mouse_filter = 2

[node name="LabelCrowd" type="Label" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_ArianaGrande/Card/CardHBox/RightArea/CrowdBadge/BadgeHBox"]
theme_override_font_sizes/font_size = 11
theme_override_colors/font_color = Color(1, 1, 1, 1)
mouse_filter = 2

[node name="LabelArtist" type="Label" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_ArianaGrande/Card/CardHBox/RightArea"]
anchor_right = 1.0
anchor_bottom = 1.0
offset_left = 12.0
offset_right = -72.0
vertical_alignment = 1
theme_override_font_sizes/font_size = 22
theme_override_colors/font_color = Color(1, 1, 1, 1)
mouse_filter = 2

[node name="Slot_ChappellRoan" type="Control" parent="MainMargin/MainVBox/CarouselStage/CardRow"]
mouse_filter = 2

[node name="Card" type="PanelContainer" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_ChappellRoan"]
custom_minimum_size = Vector2(280, 160)

[node name="CardHBox" type="HBoxContainer" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_ChappellRoan/Card"]
anchor_right = 1.0
anchor_bottom = 1.0
theme_override_constants/separation = 0
mouse_filter = 2

[node name="DoorPanel" type="Control" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_ChappellRoan/Card/CardHBox"]
custom_minimum_size = Vector2(70, 0)
size_flags_vertical = 3
mouse_filter = 2

[node name="RightArea" type="Control" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_ChappellRoan/Card/CardHBox"]
size_flags_horizontal = 3
size_flags_vertical = 3
mouse_filter = 2

[node name="BokehBg" type="ColorRect" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_ChappellRoan/Card/CardHBox/RightArea"]
anchor_right = 1.0
anchor_bottom = 1.0
mouse_filter = 2

[node name="CrowdBadge" type="PanelContainer" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_ChappellRoan/Card/CardHBox/RightArea"]
offset_left = 8.0
offset_top = 8.0
offset_right = 80.0
offset_bottom = 32.0

[node name="BadgeHBox" type="HBoxContainer" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_ChappellRoan/Card/CardHBox/RightArea/CrowdBadge"]
theme_override_constants/separation = 4
mouse_filter = 2

[node name="LabelIcon" type="Label" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_ChappellRoan/Card/CardHBox/RightArea/CrowdBadge/BadgeHBox"]
theme_override_font_sizes/font_size = 11
text = "people"
mouse_filter = 2

[node name="LabelCrowd" type="Label" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_ChappellRoan/Card/CardHBox/RightArea/CrowdBadge/BadgeHBox"]
theme_override_font_sizes/font_size = 11
theme_override_colors/font_color = Color(1, 1, 1, 1)
mouse_filter = 2

[node name="LabelArtist" type="Label" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_ChappellRoan/Card/CardHBox/RightArea"]
anchor_right = 1.0
anchor_bottom = 1.0
offset_left = 12.0
offset_right = -72.0
vertical_alignment = 1
theme_override_font_sizes/font_size = 22
theme_override_colors/font_color = Color(1, 1, 1, 1)
mouse_filter = 2

[node name="Slot_TheWeeknd" type="Control" parent="MainMargin/MainVBox/CarouselStage/CardRow"]
mouse_filter = 2

[node name="Card" type="PanelContainer" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_TheWeeknd"]
custom_minimum_size = Vector2(280, 160)

[node name="CardHBox" type="HBoxContainer" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_TheWeeknd/Card"]
anchor_right = 1.0
anchor_bottom = 1.0
theme_override_constants/separation = 0
mouse_filter = 2

[node name="DoorPanel" type="Control" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_TheWeeknd/Card/CardHBox"]
custom_minimum_size = Vector2(70, 0)
size_flags_vertical = 3
mouse_filter = 2

[node name="RightArea" type="Control" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_TheWeeknd/Card/CardHBox"]
size_flags_horizontal = 3
size_flags_vertical = 3
mouse_filter = 2

[node name="BokehBg" type="ColorRect" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_TheWeeknd/Card/CardHBox/RightArea"]
anchor_right = 1.0
anchor_bottom = 1.0
mouse_filter = 2

[node name="CrowdBadge" type="PanelContainer" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_TheWeeknd/Card/CardHBox/RightArea"]
offset_left = 8.0
offset_top = 8.0
offset_right = 80.0
offset_bottom = 32.0

[node name="BadgeHBox" type="HBoxContainer" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_TheWeeknd/Card/CardHBox/RightArea/CrowdBadge"]
theme_override_constants/separation = 4
mouse_filter = 2

[node name="LabelIcon" type="Label" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_TheWeeknd/Card/CardHBox/RightArea/CrowdBadge/BadgeHBox"]
theme_override_font_sizes/font_size = 11
text = "people"
mouse_filter = 2

[node name="LabelCrowd" type="Label" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_TheWeeknd/Card/CardHBox/RightArea/CrowdBadge/BadgeHBox"]
theme_override_font_sizes/font_size = 11
theme_override_colors/font_color = Color(1, 1, 1, 1)
mouse_filter = 2

[node name="LabelArtist" type="Label" parent="MainMargin/MainVBox/CarouselStage/CardRow/Slot_TheWeeknd/Card/CardHBox/RightArea"]
anchor_right = 1.0
anchor_bottom = 1.0
offset_left = 12.0
offset_right = -72.0
vertical_alignment = 1
theme_override_font_sizes/font_size = 22
theme_override_colors/font_color = Color(1, 1, 1, 1)
mouse_filter = 2

[node name="NavRow" type="HBoxContainer" parent="MainMargin/MainVBox"]
custom_minimum_size = Vector2(0, 56)
size_flags_horizontal = 3
alignment = 1
theme_override_constants/separation = 32
mouse_filter = 2

[node name="BtnPrev" type="Button" parent="MainMargin/MainVBox/NavRow"]
custom_minimum_size = Vector2(44, 44)
text = "<"
flat = true

[node name="BtnEnter" type="Button" parent="MainMargin/MainVBox/NavRow"]
custom_minimum_size = Vector2(180, 46)
text = "ENTER"
theme_override_styles/normal = SubResource("StyleBoxFlat_enter")
theme_override_styles/hover = SubResource("StyleBoxFlat_enter_hover")
theme_override_styles/pressed = SubResource("StyleBoxFlat_enter")
theme_override_font_sizes/font_size = 17
theme_override_colors/font_color = Color(1, 1, 1, 1)

[node name="BtnNext" type="Button" parent="MainMargin/MainVBox/NavRow"]
custom_minimum_size = Vector2(44, 44)
text = ">"
flat = true

[node name="CharOverlay" type="Control" parent="."]
anchor_left = 1.0
anchor_top = 1.0
anchor_right = 1.0
anchor_bottom = 1.0
offset_left = -80.0
offset_top = -120.0
offset_right = 0.0
offset_bottom = -20.0
grow_horizontal = 0
grow_vertical = 0
mouse_filter = 2

[node name="CharDisplay" type="TextureRect" parent="CharOverlay"]
anchor_right = 1.0
anchor_bottom = 1.0
expand_mode = 3
stretch_mode = 6
mouse_filter = 2
"""
	var path = "res://screens/home.tscn"
	var f = FileAccess.open(path, FileAccess.WRITE)
	f.store_string(tscn)
	f.close()
	print("tscn written")

func _write_gd() -> void:
	var gd : String = """extends Control

# ── Scene constants ────────────────────────────────────────────────────────────
const LOGIN_SCENE : String = "res://screens/login.tscn"

# ── Room data ──────────────────────────────────────────────────────────────────
const ROOMS : Array[Dictionary] = [
	{
		"artist":     "BRUNO\\nMARS",
		"genre":      "Pop / R&B",
		"crowd":      67,
		"door_color": Color(0.55, 0.30, 0.10),
		"bg_color1":  Color(0.55, 0.25, 0.05),
		"bg_color2":  Color(0.85, 0.45, 0.10),
		"char_color": Color(0.85, 0.65, 0.20),
		"accent":     Color(1.00, 0.65, 0.15),
	},
	{
		"artist":     "TAYLOR\\nSWIFT",
		"genre":      "Pop",
		"crowd":      67,
		"door_color": Color(0.90, 0.35, 0.55),
		"bg_color1":  Color(0.55, 0.05, 0.25),
		"bg_color2":  Color(0.90, 0.30, 0.60),
		"char_color": Color(1.00, 0.80, 0.85),
		"accent":     Color(1.00, 0.55, 0.75),
	},
	{
		"artist":     "ARIANA\\nGRANDE",
		"genre":      "Pop / R&B",
		"crowd":      67,
		"door_color": Color(0.55, 0.50, 0.80),
		"bg_color1":  Color(0.20, 0.05, 0.35),
		"bg_color2":  Color(0.55, 0.15, 0.75),
		"char_color": Color(0.80, 0.65, 1.00),
		"accent":     Color(0.75, 0.50, 1.00),
	},
	{
		"artist":     "CHAPPELL\\nROAN",
		"genre":      "Pop",
		"crowd":      67,
		"door_color": Color(0.75, 0.38, 0.12),
		"bg_color1":  Color(0.50, 0.18, 0.04),
		"bg_color2":  Color(0.90, 0.45, 0.10),
		"char_color": Color(1.00, 0.75, 0.50),
		"accent":     Color(1.00, 0.55, 0.20),
	},
	{
		"artist":     "THE\\nWEEKND",
		"genre":      "R&B",
		"crowd":      67,
		"door_color": Color(0.12, 0.12, 0.18),
		"bg_color1":  Color(0.08, 0.04, 0.20),
		"bg_color2":  Color(0.30, 0.10, 0.50),
		"char_color": Color(0.80, 0.70, 1.00),
		"accent":     Color(0.60, 0.30, 1.00),
	},
]

# ── Carousel constants ─────────────────────────────────────────────────────────
const CARD_W : float = 280.0
const CARD_H : float = 160.0
const CARD_RADIUS : int = 16
const SLIDE_DUR : float = 0.40

# ── State ──────────────────────────────────────────────────────────────────────
var _current_idx : int = 0
var _is_animating : bool = false

# ── Node refs (bound via %UniqueNames) ────────────────────────────────────────
@onready var _bg_texture : TextureRect = %BgTexture
@onready var _bg_tint : ColorRect = %BgTint
@onready var _card_row : Control = %CardRow
@onready var _stage : Control = %CarouselStage
@onready var _btn_prev : Button = %BtnPrev
@onready var _btn_next : Button = %BtnNext
@onready var _btn_enter : Button = %BtnEnter
@onready var _btn_back : Button = %BtnBack
@onready var _char_display : TextureRect = %CharDisplay

# Per-slot node refs built in _ready
var _slot_labels : Array[Label] = []
var _slot_crowds : Array[Label] = []
var _slot_bgs : Array[ColorRect] = []
var _slot_doors : Array[Control] = []

const SLOT_NAMES : Array[String] = [
	"Slot_BrunoMars",
	"Slot_TaylorSwift",
	"Slot_ArianaGrande",
	"Slot_ChappellRoan",
	"Slot_TheWeeknd",
]

# ── Fonts ──────────────────────────────────────────────────────────────────────
var _pixel_font : FontFile = null

func _ready() -> void:
	_pixel_font = load(
		"res://Pixelify_Sans/static/PixelifySans-Bold.ttf"
	) as FontFile
	_connect_signals()
	_bind_slot_refs()
	_apply_fonts()
	_populate_cards()
	_show_character()
	_snap_row()

# ── Signal wiring ──────────────────────────────────────────────────────────────
func _connect_signals() -> void:
	_btn_prev.pressed.connect(_go_prev)
	_btn_next.pressed.connect(_go_next)
	_btn_enter.pressed.connect(_on_enter_pressed)
	_btn_back.pressed.connect(_on_logout)

# ── Bind per-slot node refs from scene tree ───────────────────────────────────
func _bind_slot_refs() -> void:
	for slot_name : String in SLOT_NAMES:
		var base : String = (
			"MainMargin/MainVBox/CarouselStage/CardRow/"
			+ slot_name
		)
		var right : String = base + "/Card/CardHBox/RightArea"
		var artist_lbl : Label = get_node(
			right + "/LabelArtist"
		) as Label
		var crowd_lbl : Label = get_node(
			right + "/CrowdBadge/BadgeHBox/LabelCrowd"
		) as Label
		var bokeh : ColorRect = get_node(
			right + "/BokehBg"
		) as ColorRect
		var door : Control = get_node(
			base + "/Card/CardHBox/DoorPanel"
		) as Control
		_slot_labels.append(artist_lbl)
		_slot_crowds.append(crowd_lbl)
		_slot_bgs.append(bokeh)
		_slot_doors.append(door)

# ── Apply pixel font to all labelled nodes ────────────────────────────────────
func _apply_fonts() -> void:
	if _pixel_font == null:
		return
	for lbl : Label in _slot_labels:
		lbl.add_theme_font_override("font", _pixel_font)
	for lbl : Label in _slot_crowds:
		lbl.add_theme_font_override("font", _pixel_font)
	_btn_prev.add_theme_font_override("font", _pixel_font)
	_btn_next.add_theme_font_override("font", _pixel_font)
	_btn_enter.add_theme_font_override("font", _pixel_font)
	_btn_back.add_theme_font_override("font", _pixel_font)
	var title : Label = get_node(
		"MainMargin/MainVBox/LabelTitle"
	) as Label
	if title:
		title.add_theme_font_override("font", _pixel_font)

# ── Populate card content from ROOMS data ─────────────────────────────────────
func _populate_cards() -> void:
	for i : int in ROOMS.size():
		var data : Dictionary = ROOMS[i]
		_slot_labels[i].text = data["artist"]
		_slot_crowds[i].text = str(data["crowd"])
		_slot_bgs[i].color = data["bg_color1"]
		_style_door(_slot_doors[i], data["door_color"])
		_style_card_panel(i, data["bg_color1"])

func _style_card_panel(idx : int, bg : Color) -> void:
	var slot_name : String = SLOT_NAMES[idx]
	var card_path : String = (
		"MainMargin/MainVBox/CarouselStage/CardRow/"
		+ slot_name + "/Card"
	)
	var card : PanelContainer = get_node(card_path) as PanelContainer
	if card == null:
		return
	var style : StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = bg
	style.set_corner_radius_all(CARD_RADIUS)
	card.add_theme_stylebox_override("panel", style)

func _style_door(door : Control, col : Color) -> void:
	if door == null:
		return
	# Clear any old children drawn by previous calls
	for c : Node in door.get_children():
		c.queue_free()

	# Door background
	var door_bg : ColorRect = ColorRect.new()
	door_bg.color = col.darkened(0.3)
	door_bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	door_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	door.add_child(door_bg)

	# Door frame
	var frame : ColorRect = ColorRect.new()
	frame.color = col.lightened(0.15)
	frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	frame.offset_left = 8.0
	frame.offset_right = -8.0
	frame.offset_top = 12.0
	frame.offset_bottom = -8.0
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	door.add_child(frame)

	# Door fill
	var door_fill : ColorRect = ColorRect.new()
	door_fill.color = col
	door_fill.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	door_fill.offset_left = 12.0
	door_fill.offset_right = -12.0
	door_fill.offset_top = 16.0
	door_fill.offset_bottom = -12.0
	door_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	door.add_child(door_fill)

	# Panel stripes
	for idx : int in 3:
		var stripe : ColorRect = ColorRect.new()
		stripe.color = col.darkened(0.25)
		stripe.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		var y_off : float = 22.0 + float(idx) * 28.0
		stripe.offset_left = 14.0
		stripe.offset_right = -14.0
		stripe.offset_top = y_off
		stripe.offset_bottom = y_off + 18.0
		stripe.mouse_filter = Control.MOUSE_FILTER_IGNORE
		door.add_child(stripe)

	# Doorknob
	var knob : ColorRect = ColorRect.new()
	knob.color = Color(1.0, 0.85, 0.3)
	knob.custom_minimum_size = Vector2(6.0, 6.0)
	knob.set_anchors_and_offsets_preset(Control.PRESET_CENTER_RIGHT)
	knob.offset_right = -17.0
	knob.offset_left = -23.0
	knob.offset_top = 4.0
	knob.offset_bottom = 10.0
	knob.mouse_filter = Control.MOUSE_FILTER_IGNORE
	door.add_child(knob)

# ── Character skin display ─────────────────────────────────────────────────────
func _show_character() -> void:
	_char_display.texture = null
	_char_display.visible = false

# ── Slot sizing — positions each slot so its card is vp-width apart ───────────
func _size_slots() -> void:
	var vp_w : float = get_viewport().get_visible_rect().size.x
	var vp_h : float = _stage.size.y
	for i : int in SLOT_NAMES.size():
		var slot_name : String = SLOT_NAMES[i]
		var slot_path : String = (
			"MainMargin/MainVBox/CarouselStage/CardRow/"
			+ slot_name
		)
		var slot : Control = get_node(slot_path) as Control
		if slot == null:
			continue
		slot.position = Vector2(float(i) * vp_w, 0.0)
		slot.size = Vector2(vp_w, vp_h)
		# centre the card within the slot
		var card_path : String = slot_path + "/Card"
		var card : PanelContainer = get_node(card_path) as PanelContainer
		if card == null:
			continue
		card.position = Vector2(
			(vp_w - CARD_W) / 2.0,
			(vp_h - CARD_H) / 2.0
		)
	# Size the CardRow to span all slots
	_card_row.size = Vector2(
		float(SLOT_NAMES.size()) * vp_w,
		vp_h
	)

func _notification(what : int) -> void:
	if what == NOTIFICATION_RESIZED:
		_size_slots()
		_snap_row()

# ── Carousel navigation ────────────────────────────────────────────────────────
func _go_prev() -> void:
	_navigate(-1)

func _go_next() -> void:
	_navigate(1)

func _navigate(dir : int) -> void:
	if _is_animating:
		return
	var next : int = _current_idx + dir
	if next < 0 or next >= ROOMS.size():
		_bounce_card(dir)
		return
	_current_idx = next
	_is_animating = true
	_slide_row()

func _snap_row() -> void:
	_card_row.position.x = _row_target_x()

func _slide_row() -> void:
	var target_x : float = _row_target_x()
	var t : Tween = create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_CUBIC)
	t.tween_property(_card_row, "position:x", target_x, SLIDE_DUR)
	t.finished.connect(func() -> void: _is_animating = false)

func _row_target_x() -> float:
	var vp_w : float = get_viewport().get_visible_rect().size.x
	return -float(_current_idx) * vp_w

func _bounce_card(dir : int) -> void:
	var t : Tween = create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_BACK)
	var nudge : float = float(dir) * -18.0
	var base : float = _row_target_x()
	t.tween_property(_card_row, "position:x", base + nudge, 0.12)
	t.tween_property(_card_row, "position:x", base, 0.18)

# ── Swipe gesture ──────────────────────────────────────────────────────────────
var _swipe_start_x : float = 0.0
var _swipe_active : bool = false
const SWIPE_THRESHOLD : float = 40.0

func _input(event : InputEvent) -> void:
	if event is InputEventScreenTouch:
		var e : InputEventScreenTouch = event as InputEventScreenTouch
		if e.pressed:
			_swipe_start_x = e.position.x
			_swipe_active = true
		else:
			_swipe_active = false
	elif event is InputEventScreenDrag:
		if not _swipe_active:
			return
		var e : InputEventScreenDrag = event as InputEventScreenDrag
		var delta : float = e.position.x - _swipe_start_x
		if absf(delta) > SWIPE_THRESHOLD:
			_swipe_active = false
			if delta < 0.0:
				_go_next()
			else:
				_go_prev()

# ── Actions ────────────────────────────────────────────────────────────────────
func _on_enter_pressed() -> void:
	var room : Dictionary = ROOMS[_current_idx]
	print("Entering: ", room["artist"])
	# TODO: navigate to concert room scene

func _on_logout() -> void:
	AuthManager.logout()
	get_tree().change_scene_to_file.call_deferred(LOGIN_SCENE)
"""
	var path = "res://scripts/home.gd"
	var f = FileAccess.open(path, FileAccess.WRITE)
	f.store_string(gd)
	f.close()
	print("gd written")
