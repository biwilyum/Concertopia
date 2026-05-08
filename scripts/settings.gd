extends Control

# ── Scene constants ────────────────────────────────────────────────────────────
const LOGIN_SCENE    : String = "res://screens/login.tscn"

# ── Colors ─────────────────────────────────────────────────────────────────────
const C_BG      : Color = Color(0.0,  0.0,  0.0,  0.72)
const C_PANEL   : Color = Color(0.10, 0.07, 0.18, 1.0)
const C_BORDER  : Color = Color(0.96, 0.42, 0.62, 1.0)
const C_PINK    : Color = Color(0.96, 0.42, 0.62, 1.0)
const C_PINK_HV : Color = Color(1.0,  0.60, 0.78, 1.0)
const C_CREAM   : Color = Color(0.96, 0.91, 0.78, 1.0)
const C_MUTED   : Color = Color(0.7,  0.7,  0.7,  1.0)
const C_RED     : Color = Color(0.90, 0.25, 0.25, 1.0)
const C_RED_HV  : Color = Color(1.00, 0.35, 0.35, 1.0)

# ── Previous scene to return to ───────────────────────────────────────────────
var return_scene : String = "res://screens/home.tscn"

var _pixel_font : FontFile = null
var _body_font  : FontFile = null

func _ready() -> void:
	_pixel_font = load(
		"res://Pixelify_Sans/static/PixelifySans-Bold.ttf"
	) as FontFile
	_body_font = load(
		"res://font/Montserrat/static/Montserrat-SemiBold.ttf"
	) as FontFile
	_build_ui()

func _build_ui() -> void:
	# ── Dimmed backdrop ────────────────────────────────────────────────────────
	var backdrop := ColorRect.new()
	backdrop.color = C_BG
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(backdrop)
	# Tap outside panel to close
	backdrop.gui_input.connect(func(e: InputEvent) -> void:
		if e is InputEventMouseButton:
			var mb := e as InputEventMouseButton
			if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
				_close()
	)

	# ── Panel (centred card) ───────────────────────────────────────────────────
	var panel := PanelContainer.new()
	panel.anchor_left   = 0.5
	panel.anchor_top    = 0.5
	panel.anchor_right  = 0.5
	panel.anchor_bottom = 0.5
	panel.offset_left   = -220.0
	panel.offset_right  =  220.0
	panel.offset_top    = -280.0
	panel.offset_bottom =  280.0
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical   = Control.GROW_DIRECTION_BOTH
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = C_PANEL
	panel_style.set_corner_radius_all(20)
	panel_style.border_width_left   = 2
	panel_style.border_width_right  = 2
	panel_style.border_width_top    = 2
	panel_style.border_width_bottom = 2
	panel_style.border_color        = C_BORDER
	panel.add_theme_stylebox_override("panel", panel_style)
	add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left",   24)
	margin.add_theme_constant_override("margin_right",  24)
	margin.add_theme_constant_override("margin_top",    20)
	margin.add_theme_constant_override("margin_bottom", 20)
	panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	margin.add_child(vbox)

	# ── Header row ────────────────────────────────────────────────────────────
	var header_row := HBoxContainer.new()
	header_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(header_row)

	var title := Label.new()
	title.text = "Settings"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_color_override("font_color", C_CREAM)
	title.add_theme_font_size_override("font_size", 22)
	if _pixel_font:
		title.add_theme_font_override("font", _pixel_font)
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	header_row.add_child(title)

	var close_btn := Button.new()
	close_btn.text = "✕"
	close_btn.flat = true
	close_btn.add_theme_color_override("font_color", C_MUTED)
	close_btn.add_theme_font_size_override("font_size", 18)
	close_btn.custom_minimum_size = Vector2(32, 32)
	close_btn.pressed.connect(_close)
	header_row.add_child(close_btn)

	# ── Divider ───────────────────────────────────────────────────────────────
	_add_divider(vbox)

	# ── User info section ─────────────────────────────────────────────────────
	_add_section_label(vbox, "ACCOUNT")

	var user : Dictionary = AuthManager.current_user
	var display_name = user.get("display_name", "Guest")
	var email_str    = user.get("email", "")
	var full_name    = user.get("full_name", "")
	var age          = user.get("age", "")
	var bio          = user.get("bio", "")

	display_name = str(display_name) if display_name != null else "Guest"
	email_str = str(email_str) if email_str != null else ""
	full_name = str(full_name) if full_name != null else ""
	age = str(age) if age != null else ""
	bio = str(bio) if bio != null else ""

	_add_info_row(vbox, "> Display Name", display_name)
	_add_info_row(vbox, "> Email",        email_str)
	if !full_name.is_empty():
		_add_info_row(vbox, "> Full Name", full_name)
	if age != "0" and !age.is_empty():
		_add_info_row(vbox, "> Age",       age)
	if !bio.is_empty():
		_add_info_row(vbox, "> Bio",       bio)

	_add_divider(vbox)

	# ── App section ───────────────────────────────────────────────────────────
	_add_section_label(vbox, "APP")
	_add_toggle_row(vbox, "> Sound Effects",    true)
	_add_toggle_row(vbox, "> Background Music",  true)
	_add_toggle_row(vbox, "> Notifications",     false)

	_add_divider(vbox)

	# ── Danger zone ───────────────────────────────────────────────────────────
	_add_section_label(vbox, "ACCOUNT ACTIONS")
	_add_action_btn(vbox, "[ CHANGE PASSWORD ]", C_MUTED, Color(0.85, 0.85, 0.85), _on_change_password)
	_add_action_btn(vbox, "[ LOG OUT ]",          C_RED,   C_RED_HV,               _on_logout)

# ── UI helpers ─────────────────────────────────────────────────────────────────

func _add_section_label(parent: Control, text: String) -> void:
	var lbl := Label.new()
	lbl.text = text
	lbl.add_theme_color_override("font_color", C_PINK)
	lbl.add_theme_font_size_override("font_size", 10)
	if _pixel_font:
		lbl.add_theme_font_override("font", _pixel_font)
	lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(lbl)

func _add_info_row(parent: Control, label: String, value: String) -> void:
	var row := HBoxContainer.new()
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(row)

	var lbl := Label.new()
	lbl.text = label
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl.add_theme_color_override("font_color", C_MUTED)
	lbl.add_theme_font_size_override("font_size", 12)
	if _body_font:
		lbl.add_theme_font_override("font", _body_font)
	lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(lbl)

	var val := Label.new()
	val.text = value
	val.add_theme_color_override("font_color", C_CREAM)
	val.add_theme_font_size_override("font_size", 12)
	if _body_font:
		val.add_theme_font_override("font", _body_font)
	val.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(val)

func _add_action_btn(
	parent   : Control,
	text     : String,
	col      : Color,
	col_hv   : Color,
	callback : Callable
) -> void:
	var btn := Button.new()
	btn.text = text
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.custom_minimum_size   = Vector2(0, 38)
	var sn := StyleBoxFlat.new()
	sn.bg_color = Color(col.r, col.g, col.b, 0.15)
	sn.set_corner_radius_all(10)
	sn.content_margin_left  = 12
	sn.content_margin_right = 12
	var sh := StyleBoxFlat.new()
	sh.bg_color = Color(col_hv.r, col_hv.g, col_hv.b, 0.30)
	sh.set_corner_radius_all(10)
	sh.content_margin_left  = 12
	sh.content_margin_right = 12
	btn.add_theme_stylebox_override("normal",  sn)
	btn.add_theme_stylebox_override("hover",   sh)
	btn.add_theme_stylebox_override("pressed", sn)
	btn.add_theme_color_override("font_color", col)
	btn.add_theme_font_size_override("font_size", 13)
	if _body_font:
		btn.add_theme_font_override("font", _body_font)
	btn.pressed.connect(callback)
	parent.add_child(btn)

func _add_toggle_row(parent: Control, label: String, default_on: bool) -> void:
	var row := HBoxContainer.new()
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(row)

	var lbl := Label.new()
	lbl.text = label
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl.add_theme_color_override("font_color", C_CREAM)
	lbl.add_theme_font_size_override("font_size", 12)
	if _pixel_font:
		lbl.add_theme_font_override("font", _pixel_font)
	lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(lbl)

	# Simple ON/OFF label toggle (no CheckBox which needs a theme)
	var toggle := Button.new()
	toggle.text = "ON" if default_on else "OFF"
	toggle.custom_minimum_size = Vector2(48, 26)
	var ts := StyleBoxFlat.new()
	ts.bg_color = C_PINK if default_on else Color(0.3, 0.3, 0.3)
	ts.set_corner_radius_all(0)
	ts.border_width_left = 2
	ts.border_width_right = 2
	ts.border_width_top = 2
	ts.border_width_bottom = 2
	ts.border_color = Color(1, 1, 1) if default_on else Color(0.3, 0.3, 0.3)
	toggle.add_theme_stylebox_override("normal",  ts)
	toggle.add_theme_stylebox_override("hover",   ts)
	toggle.add_theme_stylebox_override("pressed", ts)
	toggle.add_theme_color_override("font_color", Color(1, 1, 1))
	toggle.add_theme_font_size_override("font_size", 12)
	if _pixel_font: toggle.add_theme_font_override("font", _pixel_font)
	var is_on : bool = default_on
	toggle.pressed.connect(func() -> void:
		is_on = not is_on
		toggle.text = "ON" if is_on else "OFF"
		var new_style := StyleBoxFlat.new()
		new_style.bg_color = C_PINK if is_on else Color(0.3, 0.3, 0.3)
		new_style.set_corner_radius_all(0)
		new_style.border_width_left = 2
		new_style.border_width_right = 2
		new_style.border_width_top = 2
		new_style.border_width_bottom = 2
		new_style.border_color = Color(1, 1, 1) if is_on else Color(0.3, 0.3, 0.3)
		toggle.add_theme_stylebox_override("normal",  new_style)
		toggle.add_theme_stylebox_override("hover",   new_style)
		toggle.add_theme_stylebox_override("pressed", new_style)
	)
	row.add_child(toggle)

func _add_divider(parent: Control) -> void:
	var line := ColorRect.new()
	line.color = Color(1, 1, 1, 0.08)
	line.custom_minimum_size = Vector2(0, 1)
	line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(line)

# ── Actions ────────────────────────────────────────────────────────────────────

func _on_change_password() -> void:
	var changepass_scene : String = "res://screens/changepass.tscn"
	get_tree().change_scene_to_file.call_deferred(changepass_scene)

func _on_logout() -> void:
	AuthManager.logout()
	get_tree().change_scene_to_file.call_deferred(LOGIN_SCENE)

func _close() -> void:
	get_tree().change_scene_to_file.call_deferred(return_scene)
