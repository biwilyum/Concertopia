@tool
extends EditorScript

# ── helpers ────────────────────────────────────────────────────────────────────

func _add(parent: Node, child: Node, uname: bool = false) -> Node:
	parent.add_child(child)
	child.owner = _root
	if uname:
		child.unique_name_in_owner = true
	return child

func _flat(col: Color, radius: int = 0) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = col
	if radius > 0:
		s.set_corner_radius_all(radius)
	return s

# ── root reference kept for owner assignment ───────────────────────────────────
var _root: Control = null

# ── entry ──────────────────────────────────────────────────────────────────────

func _run() -> void:
	_build_scene()

func _build_scene() -> void:
	# ── root ──────────────────────────────────────────────────────────────────
	var root := Control.new()
	root.name = "Home"
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_root = root

	var scr_path := "res://scripts/home.gd"
	var scr := load(scr_path) as Script
	root.set_script(scr)

	# ── backgrounds ───────────────────────────────────────────────────────────
	var bg_color := ColorRect.new()
	bg_color.name = "BgColor"
	bg_color.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg_color.color = Color(0.04, 0.02, 0.10)
	bg_color.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(root, bg_color)

	var bg_tex := TextureRect.new()
	bg_tex.name = "BgTexture"
	bg_tex.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg_tex.stretch_mode = TextureRect.STRETCH_SCALE
	bg_tex.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	bg_tex.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(root, bg_tex, true)

	var bg_tint := ColorRect.new()
	bg_tint.name = "BgTint"
	bg_tint.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg_tint.color = Color(0.0, 0.0, 0.0, 0.45)
	bg_tint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(root, bg_tint, true)

	# ── top bar ───────────────────────────────────────────────────────────────
	var top_bar := MarginContainer.new()
	top_bar.name = "TopBar"
	top_bar.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	top_bar.offset_bottom = 56.0
	top_bar.add_theme_constant_override("margin_left", 16)
	top_bar.add_theme_constant_override("margin_right", 16)
	top_bar.add_theme_constant_override("margin_top", 8)
	top_bar.add_theme_constant_override("margin_bottom", 8)
	top_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(root, top_bar)

	var top_hbox := HBoxContainer.new()
	top_hbox.name = "TopHBox"
	top_hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(top_bar, top_hbox)

	var btn_back := Button.new()
	btn_back.name = "BtnBack"
	btn_back.text = "< Back"
	btn_back.flat = true
	btn_back.custom_minimum_size = Vector2(90, 36)
	btn_back.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	_add(top_hbox, btn_back, true)

	var top_spacer := Control.new()
	top_spacer.name = "TopSpacer"
	top_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(top_hbox, top_spacer)

	# ── main margin ───────────────────────────────────────────────────────────
	var main_margin := MarginContainer.new()
	main_margin.name = "MainMargin"
	main_margin.anchor_left = 0.0
	main_margin.anchor_top = 0.0
	main_margin.anchor_right = 1.0
	main_margin.anchor_bottom = 1.0
	main_margin.offset_top = 56.0
	main_margin.grow_horizontal = Control.GROW_DIRECTION_BOTH
	main_margin.grow_vertical = Control.GROW_DIRECTION_BOTH
	main_margin.add_theme_constant_override("margin_left", 0)
	main_margin.add_theme_constant_override("margin_right", 0)
	main_margin.add_theme_constant_override("margin_top", 16)
	main_margin.add_theme_constant_override("margin_bottom", 24)
	main_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(root, main_margin)

	var main_vbox := VBoxContainer.new()
	main_vbox.name = "MainVBox"
	main_vbox.add_theme_constant_override("separation", 24)
	main_vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(main_margin, main_vbox)

	# title label
	var lbl_title := Label.new()
	lbl_title.name = "LabelTitle"
	lbl_title.text = "Choose Artist's Concert Room"
	lbl_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl_title.custom_minimum_size = Vector2(0, 48)
	lbl_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl_title.add_theme_font_size_override("font_size", 22)
	lbl_title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(main_vbox, lbl_title)

	# ── carousel stage ────────────────────────────────────────────────────────
	var stage := Control.new()
	stage.name = "CarouselStage"
	stage.clip_contents = true
	stage.custom_minimum_size = Vector2(0, 200)
	stage.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stage.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(main_vbox, stage, true)

	var card_row := Control.new()
	card_row.name = "CardRow"
	card_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(stage, card_row, true)

	# ── 5 room slots ──────────────────────────────────────────────────────────
	var slot_names := [
		"Slot_BrunoMars",
		"Slot_TaylorSwift",
		"Slot_ArianaGrande",
		"Slot_ChappellRoan",
		"Slot_TheWeeknd",
	]
	for sname: String in slot_names:
		_build_slot(card_row, sname)

	# ── nav row ───────────────────────────────────────────────────────────────
	var nav_row := HBoxContainer.new()
	nav_row.name = "NavRow"
	nav_row.custom_minimum_size = Vector2(0, 56)
	nav_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	nav_row.alignment = BoxContainer.ALIGNMENT_CENTER
	nav_row.add_theme_constant_override("separation", 32)
	nav_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(main_vbox, nav_row)

	var btn_prev := Button.new()
	btn_prev.name = "BtnPrev"
	btn_prev.text = "<"
	btn_prev.flat = true
	btn_prev.custom_minimum_size = Vector2(44, 44)
	_add(nav_row, btn_prev, true)

	var btn_enter := Button.new()
	btn_enter.name = "BtnEnter"
	btn_enter.text = "ENTER"
	btn_enter.custom_minimum_size = Vector2(180, 46)
	btn_enter.add_theme_font_size_override("font_size", 17)
	btn_enter.add_theme_color_override("font_color", Color(1, 1, 1))
	var enter_normal := _flat(Color(0.96, 0.57, 0.72), 23)
	enter_normal.content_margin_left = 24
	enter_normal.content_margin_right = 24
	enter_normal.content_margin_top = 10
	enter_normal.content_margin_bottom = 10
	var enter_hover := _flat(Color(1.0, 0.70, 0.82), 23)
	enter_hover.content_margin_left = 24
	enter_hover.content_margin_right = 24
	enter_hover.content_margin_top = 10
	enter_hover.content_margin_bottom = 10
	btn_enter.add_theme_stylebox_override("normal", enter_normal)
	btn_enter.add_theme_stylebox_override("hover", enter_hover)
	btn_enter.add_theme_stylebox_override("pressed", enter_normal)
	_add(nav_row, btn_enter, true)

	var btn_next := Button.new()
	btn_next.name = "BtnNext"
	btn_next.text = ">"
	btn_next.flat = true
	btn_next.custom_minimum_size = Vector2(44, 44)
	_add(nav_row, btn_next, true)

	# ── character overlay ─────────────────────────────────────────────────────
	var char_overlay := Control.new()
	char_overlay.name = "CharOverlay"
	char_overlay.anchor_left = 1.0
	char_overlay.anchor_top = 1.0
	char_overlay.anchor_right = 1.0
	char_overlay.anchor_bottom = 1.0
	char_overlay.offset_left = -80.0
	char_overlay.offset_top = -120.0
	char_overlay.offset_right = 0.0
	char_overlay.offset_bottom = -20.0
	char_overlay.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	char_overlay.grow_vertical = Control.GROW_DIRECTION_BEGIN
	char_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(root, char_overlay)

	var char_display := TextureRect.new()
	char_display.name = "CharDisplay"
	char_display.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	char_display.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
	char_display.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	char_display.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(char_overlay, char_display, true)

	# ── pack and save ─────────────────────────────────────────────────────────
	var packed := PackedScene.new()
	var result := packed.pack(root)
	print("pack result: " + str(result))
	var err := ResourceSaver.save(packed, "res://screens/home.tscn")
	print("save result: " + str(err))
	root.queue_free()


func _build_slot(card_row: Control, sname: String) -> void:
	var slot := Control.new()
	slot.name = sname
	slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(card_row, slot)

	var card := PanelContainer.new()
	card.name = "Card"
	card.custom_minimum_size = Vector2(280, 160)
	_add(slot, card)

	var card_hbox := HBoxContainer.new()
	card_hbox.name = "CardHBox"
	card_hbox.add_theme_constant_override("separation", 0)
	card_hbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	card_hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(card, card_hbox)

	# door panel (left column — colored procedurally at runtime)
	var door := Control.new()
	door.name = "DoorPanel"
	door.custom_minimum_size = Vector2(70, 0)
	door.size_flags_vertical = Control.SIZE_EXPAND_FILL
	door.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(card_hbox, door)

	# right content area
	var right := Control.new()
	right.name = "RightArea"
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(card_hbox, right)

	# bokeh background (tinted at runtime)
	var bokeh := ColorRect.new()
	bokeh.name = "BokehBg"
	bokeh.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bokeh.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(right, bokeh)

	# crowd badge
	var badge := PanelContainer.new()
	badge.name = "CrowdBadge"
	badge.offset_left = 8.0
	badge.offset_top = 8.0
	badge.offset_right = 84.0
	badge.offset_bottom = 32.0
	var badge_style := _flat(Color(0, 0, 0, 0.55), 10)
	badge_style.content_margin_left = 6
	badge_style.content_margin_right = 8
	badge_style.content_margin_top = 3
	badge_style.content_margin_bottom = 3
	badge.add_theme_stylebox_override("panel", badge_style)
	_add(right, badge)

	var badge_hbox := HBoxContainer.new()
	badge_hbox.name = "BadgeHBox"
	badge_hbox.add_theme_constant_override("separation", 4)
	badge_hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(badge, badge_hbox)

	var lbl_icon := Label.new()
	lbl_icon.name = "LabelIcon"
	lbl_icon.text = ":)"
	lbl_icon.add_theme_font_size_override("font_size", 11)
	lbl_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(badge_hbox, lbl_icon)

	var lbl_crowd := Label.new()
	lbl_crowd.name = "LabelCrowd"
	lbl_crowd.text = "67"
	lbl_crowd.add_theme_font_size_override("font_size", 11)
	lbl_crowd.add_theme_color_override("font_color", Color(1, 1, 1))
	lbl_crowd.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(badge_hbox, lbl_crowd)

	# artist name label
	var lbl_artist := Label.new()
	lbl_artist.name = "LabelArtist"
	lbl_artist.text = "ARTIST"
	lbl_artist.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl_artist.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	lbl_artist.offset_left = 12.0
	lbl_artist.offset_right = -72.0
	lbl_artist.add_theme_font_size_override("font_size", 22)
	lbl_artist.add_theme_color_override("font_color", Color(1, 1, 1))
	lbl_artist.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(right, lbl_artist)
