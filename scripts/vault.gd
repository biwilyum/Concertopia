extends Control

# ── Vault Reconstruction ──
# Mapped directly to public.profiles: avatar_history (JSONB) and nft_history (JSONB)

const HOME_SCENE = "res://screens/home.tscn"

# ── Visual Constants ───────────────────────────────────────────────────────────
const C_BG      : Color = Color(0.04, 0.03, 0.10)
const C_PANEL   : Color = Color(0.12, 0.08, 0.24)
const C_PINK    : Color = Color(0.96, 0.42, 0.62)
const C_GOLD    : Color = Color(0.98, 0.8, 0.1)
const C_CREAM   : Color = Color(0.96, 0.91, 0.78)
const C_MUTED   : Color = Color(0.55, 0.55, 0.65)
const C_BLACK_TR : Color = Color(0, 0, 0, 0.6)

var pixel_font : FontFile
var body_font  : FontFile

# ── UI Nodes ───────────────────────────────────────────────────────────────────
var grid_container : GridContainer
var scroll_area    : ScrollContainer
var av_tab_btn     : Button
var nft_tab_btn    : Button
var empty_state    : VBoxContainer

# ── Lifecycle ──────────────────────────────────────────────────────────────────
func _ready() -> void:
	pixel_font = load("res://Pixelify_Sans/static/PixelifySans-Bold.ttf") as FontFile
	body_font  = load("res://font/Montserrat/static/Montserrat-SemiBold.ttf") as FontFile
	
	print("[VAULT TRACE] Ready called. Current User ID: ", AuthManager.user_id)
	
	# Connect to AuthManager to refresh if data arrives late
	if not AuthManager.login_success.is_connected(_on_auth_refresh):
		AuthManager.login_success.connect(_on_auth_refresh)
	if not AuthManager.profile_updated.is_connected(_on_profile_refresh):
		AuthManager.profile_updated.connect(_on_profile_refresh)
	
	_build_ui()
	_load_avatars() # Initial load

func _on_auth_refresh(_u):
	print("[VAULT TRACE] Login success signal received.")
	_load_avatars()

func _on_profile_refresh():
	print("[VAULT TRACE] Profile updated signal received.")
	_load_avatars()

# ══════════════════════════════════════════════════════════════════════════════
# UI ARCHITECTURE
# ══════════════════════════════════════════════════════════════════════════════

func _build_ui() -> void:
	# 1. Background
	var bg := ColorRect.new()
	bg.color = C_BG
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	
	# 2. Main Margin Container
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left",   60)
	margin.add_theme_constant_override("margin_right",  60)
	margin.add_theme_constant_override("margin_top",    60)
	margin.add_theme_constant_override("margin_bottom", 60)
	add_child(margin)

	var main_vbox := VBoxContainer.new()
	main_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_vbox.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	main_vbox.add_theme_constant_override("separation", 40)
	margin.add_child(main_vbox)

	# 3. Header Section
	var header := HBoxContainer.new()
	header.custom_minimum_size = Vector2(0, 80)
	main_vbox.add_child(header)

	var title := Label.new()
	title.text = "COLLECTION VAULT"
	title.add_theme_font_size_override("font_size", 52)
	title.add_theme_color_override("font_color", C_CREAM)
	if pixel_font: title.add_theme_font_override("font", pixel_font)
	header.add_child(title)

	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(spacer)

	var back_btn := _styled_button("EXIT VAULT", C_PINK, Color.WHITE)
	back_btn.pressed.connect(func(): get_tree().change_scene_to_file(HOME_SCENE))
	header.add_child(back_btn)

	# 4. Tabs
	var nav := HBoxContainer.new()
	nav.add_theme_constant_override("separation", 20)
	main_vbox.add_child(nav)

	av_tab_btn = _tab_button("AVATARS", C_PINK)
	av_tab_btn.pressed.connect(_load_avatars)
	nav.add_child(av_tab_btn)

	nft_tab_btn = _tab_button("NFTS", C_GOLD)
	nft_tab_btn.pressed.connect(_load_nfts)
	nav.add_child(nft_tab_btn)

	# 5. Content Stack
	var stack = PanelContainer.new()
	stack.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stack.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	main_vbox.add_child(stack)

	# Scroll Container
	scroll_area = ScrollContainer.new()
	scroll_area.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll_area.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll_area.vertical_scroll_mode   = ScrollContainer.SCROLL_MODE_AUTO
	stack.add_child(scroll_area)

	# Grid
	grid_container = GridContainer.new()
	grid_container.columns = 3
	grid_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid_container.add_theme_constant_override("h_separation", 35)
	grid_container.add_theme_constant_override("v_separation", 35)
	scroll_area.add_child(grid_container)

	# Empty State
	empty_state = VBoxContainer.new()
	empty_state.alignment = BoxContainer.ALIGNMENT_CENTER
	empty_state.visible = false
	stack.add_child(empty_state)
	
	var empty_lbl = Label.new()
	empty_lbl.text = "COLLECTION EMPTY"
	empty_lbl.add_theme_color_override("font_color", C_MUTED)
	empty_lbl.add_theme_font_size_override("font_size", 28)
	if pixel_font: empty_lbl.add_theme_font_override("font", pixel_font)
	empty_state.add_child(empty_lbl)

# ══════════════════════════════════════════════════════════════════════════════
# DATA LOADING
# ══════════════════════════════════════════════════════════════════════════════

func _load_avatars() -> void:
	_clear_view()
	_set_active_tab("avatar")
	var history = AuthManager.current_user.get("avatar_history", [])
	print("[VAULT] Loading Avatars. Found: ", history.size())
	
	if history.is_empty():
		empty_state.visible = true
		scroll_area.visible = false
	else:
		empty_state.visible = false
		scroll_area.visible = true
		for i in history.size():
			_create_card(str(history[i]), "avatar", i)

func _load_nfts() -> void:
	_clear_view()
	_set_active_tab("nft")
	var history = AuthManager.current_user.get("nft_history", [])
	print("[VAULT] Loading NFTs. Found: ", history.size())
	
	if history.is_empty():
		empty_state.visible = true
		scroll_area.visible = false
	else:
		empty_state.visible = false
		scroll_area.visible = true
		for i in history.size():
			var data = history[i]
			var url = data.get("url", "") if data is Dictionary else str(data)
			_create_card(url, "nft", i, data if data is Dictionary else {})

func _create_card(url: String, type: String, _idx: int, meta: Dictionary = {}) -> void:
	if url.is_empty(): return

	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(300, 300)
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var style := StyleBoxFlat.new()
	style.bg_color = C_PANEL
	style.border_width_left = 6; style.border_width_right = 6
	style.border_width_top = 6; style.border_width_bottom = 6
	
	var is_active = (type == "avatar" and url == AuthManager.current_user.get("avatar_url", ""))
	style.border_color = Color.WHITE if is_active else (C_PINK if type == "avatar" else C_GOLD)
	style.set_corner_radius_all(0)
	style.shadow_color = Color(0, 0, 0, 0.5); style.shadow_size = 8; style.shadow_offset = Vector2(8, 8)
	card.add_theme_stylebox_override("panel", style)
	grid_container.add_child(card)
	
	# Image
	var tex := TextureRect.new()
	tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	tex.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	card.add_child(tex)

	# Overlay
	var overlay := VBoxContainer.new()
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(overlay)

	if is_active:
		var badge := Label.new()
		badge.text = " ACTIVE "
		badge.add_theme_color_override("font_color", Color.BLACK)
		badge.add_theme_font_size_override("font_size", 12)
		if pixel_font: badge.add_theme_font_override("font", pixel_font)
		var b_style = StyleBoxFlat.new()
		b_style.bg_color = Color.WHITE
		badge.add_theme_stylebox_override("normal", b_style)
		overlay.add_child(badge)
		badge.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	overlay.add_child(spacer)

	if type == "nft":
		var info = PanelContainer.new()
		var ib_style = StyleBoxFlat.new()
		ib_style.bg_color = C_BLACK_TR
		info.add_theme_stylebox_override("panel", ib_style)
		overlay.add_child(info)
		
		var lbl := Label.new()
		var ts = meta.get("timestamp", 0)
		if ts > 0:
			var d = Time.get_datetime_dict_from_unix_time(int(ts))
			lbl.text = "MINTED: %02d/%02d" % [d.day, d.month]
		else:
			lbl.text = "COLLECTIBLE"
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.add_theme_font_size_override("font_size", 10)
		if body_font: lbl.add_theme_font_override("font", body_font)
		info.add_child(lbl)

	# Load
	UIUtils.add_shimmer(tex)
	var http = HTTPRequest.new()
	card.add_child(http)
	http.request_completed.connect(func(_res, code, _hdrs, body):
		if not is_instance_valid(tex): return
		UIUtils.remove_shimmer(tex)
		if code == 200:
			var img = Image.new()
			if img.load_jpg_from_buffer(body) == OK or img.load_png_from_buffer(body) == OK or img.load_webp_from_buffer(body) == OK:
				tex.texture = ImageTexture.create_from_image(img)
				print("[VAULT] Card loaded at: ", card.global_position)
	)
	http.request(url)

	# Input
	card.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	card.mouse_entered.connect(func():
		create_tween().tween_property(card, "modulate", Color(1.2, 1.2, 1.2), 0.1)
		AudioManager.play("hover")
	)
	card.mouse_exited.connect(func():
		create_tween().tween_property(card, "modulate", Color(1.0, 1.0, 1.0), 0.1)
	)
	card.gui_input.connect(func(event):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if type == "avatar":
				_apply_avatar(url)
	)

func _apply_avatar(url: String) -> void:
	AudioManager.play("success")
	AuthManager.current_user["avatar_url"] = url
	AuthManager.update_user_details({"avatar_url": url})
	UIUtils.show_toast("Identity Updated!", C_PINK)
	_load_avatars()

func _clear_view() -> void:
	for c in grid_container.get_children(): c.queue_free()

func _set_active_tab(type: String) -> void:
	var av = (type == "avatar")
	av_tab_btn.modulate = Color.WHITE if av else Color(0.6, 0.6, 0.7)
	nft_tab_btn.modulate = Color.WHITE if !av else Color(0.6, 0.6, 0.7)

func _tab_button(txt: String, col: Color) -> Button:
	var btn := Button.new()
	btn.text = txt
	btn.custom_minimum_size = Vector2(200, 55)
	var style := StyleBoxFlat.new()
	style.bg_color = col.darkened(0.3)
	style.border_width_bottom = 4; style.border_color = col
	btn.add_theme_stylebox_override("normal", style)
	btn.add_theme_stylebox_override("hover", style)
	btn.add_theme_stylebox_override("pressed", style)
	if pixel_font: btn.add_theme_font_override("font", pixel_font)
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	return btn

func _styled_button(txt: String, col: Color, txt_col: Color) -> Button:
	var btn := Button.new()
	btn.text = txt
	btn.custom_minimum_size = Vector2(180, 48)
	var style := StyleBoxFlat.new()
	style.bg_color = col
	btn.add_theme_stylebox_override("normal", style)
	btn.add_theme_color_override("font_color", txt_col)
	if pixel_font: btn.add_theme_font_override("font", pixel_font)
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	return btn
