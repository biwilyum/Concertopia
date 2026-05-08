extends Control

const NEXT_SCENE : String = "res://screens/avatar_generation.tscn"

var pixel_font : FontFile
var body_font  : FontFile

var display_name_edit : LineEdit
var full_name_edit : LineEdit
var age_edit : LineEdit
var genre_btn : MenuButton
var selected_genres : Array[String] = []

var submit_button : Button
var error_label : Label

# ── Colors ─────────────────────────────────────────────────────────────────────
const C_BG      : Color = Color(0.04, 0.03, 0.10)
const C_PANEL   : Color = Color(0.12, 0.08, 0.24)
const C_PINK    : Color = Color(0.96, 0.42, 0.62)
const C_CREAM   : Color = Color(0.96, 0.91, 0.78)
const C_MUTED   : Color = Color(0.55, 0.55, 0.65)

func _ready() -> void:
	pixel_font = load("res://Pixelify_Sans/static/PixelifySans-Bold.ttf") as FontFile
	body_font  = load("res://font/Montserrat/static/Montserrat-SemiBold.ttf") as FontFile
	_build_ui()

func _build_ui() -> void:
	# 1. Fullscreen Background
	var bg := ColorRect.new()
	bg.color = C_BG
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	# 2. Center Container to hold the card
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	# 3. Panel Container (The Card)
	var card := PanelContainer.new()
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = C_PANEL
	card_style.set_corner_radius_all(20)
	card_style.content_margin_left = 50
	card_style.content_margin_right = 50
	card_style.content_margin_top = 40
	card_style.content_margin_bottom = 40
	card.add_theme_stylebox_override("panel", card_style)
	center.add_child(card)

	var main_vbox := VBoxContainer.new()
	main_vbox.add_theme_constant_override("separation", 30)
	card.add_child(main_vbox)

	# 4. Header
	var title_vbox := VBoxContainer.new()
	title_vbox.add_theme_constant_override("separation", 5)
	main_vbox.add_child(title_vbox)

	var title := Label.new()
	title.text = "SIGNUP INFO"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 36)
	title.add_theme_color_override("font_color", C_PINK)
	if pixel_font: title.add_theme_font_override("font", pixel_font)
	title_vbox.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Tell us a bit about yourself"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 14)
	subtitle.add_theme_color_override("font_color", C_MUTED)
	if body_font: subtitle.add_theme_font_override("font", body_font)
	title_vbox.add_child(subtitle)

	# 5. The 2x2 Grid Container
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 30)
	grid.add_theme_constant_override("v_separation", 20)
	grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	main_vbox.add_child(grid)

	display_name_edit = _create_input_field(grid, "Display Name", "How others see you")
	full_name_edit = _create_input_field(grid, "Full Name", "Your real name")
	age_edit = _create_input_field(grid, "Age", "e.g. 21")
	genre_btn = _create_genre_dropdown(grid)

	if AuthManager.current_user.has("display_name"):
		display_name_edit.text = AuthManager.current_user["display_name"]

	# 6. Error Label
	error_label = Label.new()
	error_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	error_label.add_theme_color_override("font_color", Color(1, 0.4, 0.4))
	error_label.add_theme_font_size_override("font_size", 14)
	error_label.visible = false
	if body_font: error_label.add_theme_font_override("font", body_font)
	main_vbox.add_child(error_label)

	# 7. Submit Button
	submit_button = Button.new()
	submit_button.text = "CONTINUE"
	submit_button.custom_minimum_size = Vector2(300, 50)
	submit_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
	var btn_style := StyleBoxFlat.new()
	btn_style.bg_color = C_PINK
	btn_style.set_corner_radius_all(12)
	submit_button.add_theme_stylebox_override("normal", btn_style)
	submit_button.add_theme_stylebox_override("hover", btn_style)
	submit_button.add_theme_stylebox_override("pressed", btn_style)
	submit_button.add_theme_font_size_override("font_size", 20)
	submit_button.add_theme_color_override("font_color", Color.WHITE)
	if pixel_font: submit_button.add_theme_font_override("font", pixel_font)
	submit_button.pressed.connect(_on_submit_pressed)
	main_vbox.add_child(submit_button)

func _create_input_field(parent: Node, label_text: String, placeholder: String) -> LineEdit:
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	parent.add_child(vbox)

	var lbl := Label.new()
	lbl.text = label_text
	lbl.add_theme_font_size_override("font_size", 14)
	lbl.add_theme_color_override("font_color", C_CREAM)
	if pixel_font: lbl.add_theme_font_override("font", pixel_font)
	vbox.add_child(lbl)
	
	var edit := LineEdit.new()
	edit.placeholder_text = placeholder
	edit.add_theme_font_size_override("font_size", 14)
	edit.custom_minimum_size = Vector2(240, 50)
	
	var style := StyleBoxFlat.new()
	style.bg_color = Color(1, 1, 1, 1)
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_right = 12
	style.corner_radius_bottom_left = 12
	style.content_margin_left = 15
	
	edit.add_theme_stylebox_override("normal", style)
	edit.add_theme_stylebox_override("focus", style)
	edit.add_theme_color_override("font_color", Color.BLACK)
	edit.add_theme_color_override("font_placeholder_color", Color(0.4, 0.4, 0.4, 0.6))
	edit.add_theme_color_override("caret_color", Color(0.1, 0.1, 0.1, 1))
	if body_font: edit.add_theme_font_override("font", body_font)
	
	vbox.add_child(edit)
	return edit

func _create_genre_dropdown(parent: Node) -> MenuButton:
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	parent.add_child(vbox)

	var lbl := Label.new()
	lbl.text = "Favorite Genres"
	lbl.add_theme_font_size_override("font_size", 14)
	lbl.add_theme_color_override("font_color", C_CREAM)
	if pixel_font: lbl.add_theme_font_override("font", pixel_font)
	vbox.add_child(lbl)
	
	var btn := MenuButton.new()
	btn.text = "Select Genres..."
	btn.custom_minimum_size = Vector2(240, 50)
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.clip_text = true
	
	var style := StyleBoxFlat.new()
	style.bg_color = Color(1, 1, 1, 1)
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_right = 12
	style.corner_radius_bottom_left = 12
	style.content_margin_left = 15
	style.content_margin_right = 15
	
	btn.add_theme_stylebox_override("normal", style)
	btn.add_theme_stylebox_override("hover", style)
	btn.add_theme_stylebox_override("pressed", style)
	btn.add_theme_stylebox_override("focus", style)
	btn.add_theme_color_override("font_color", Color.BLACK)
	if body_font: btn.add_theme_font_override("font", body_font)
	
	var popup = btn.get_popup()
	popup.hide_on_checkable_item_selection = false
	
	var genres = ["Pop", "R&B", "Hip Hop", "Rock", "Country", "Electronic", "Jazz", "Classical", "Indie", "K-Pop", "Latin"]
	for i in genres.size():
		popup.add_check_item(genres[i])
		
	popup.id_pressed.connect(func(id: int):
		var is_checked = popup.is_item_checked(id)
		popup.set_item_checked(id, not is_checked)
		
		selected_genres.clear()
		for j in popup.item_count:
			if popup.is_item_checked(j):
				selected_genres.append(popup.get_item_text(j))
		
		if selected_genres.is_empty():
			btn.text = "Select Genres..."
		else:
			btn.text = ", ".join(selected_genres)
	)
	
	vbox.add_child(btn)
	return btn

func _on_submit_pressed() -> void:
	var d_name : String = display_name_edit.text.strip_edges()
	var f_name : String = full_name_edit.text.strip_edges()
	var age_str : String = age_edit.text.strip_edges()
	var bio : String = ", ".join(selected_genres)

	if d_name.is_empty():
		_show_error("Display name is required.")
		return
	
	var age : int = age_str.to_int()
	if age <= 0 and not age_str.is_empty():
		_show_error("Please enter a valid age.")
		return

	_show_error("")
	submit_button.disabled = true
	submit_button.text = "SAVING..."

	AuthManager.update_user_details({
		"display_name": d_name,
		"full_name": f_name,
		"age": age,
		"bio": bio
	})

	# Wait a moment for UX and to let the request send, then transition
	await get_tree().create_timer(0.5).timeout
	if is_inside_tree():
		if AuthManager.needs_avatar_generation():
			get_tree().change_scene_to_file(NEXT_SCENE)
		else:
			get_tree().change_scene_to_file("res://screens/welcome_screen1.tscn")

func _show_error(msg: String) -> void:
	if error_label:
		error_label.text = msg
		error_label.visible = !msg.is_empty()
