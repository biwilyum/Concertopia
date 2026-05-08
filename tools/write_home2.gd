@tool
extends EditorScript

func _run() -> void:
	_write()

func _write() -> void:
	var scene_uid := "uid://lx1pkcy01okq"
	var script_uid := "uid://cq2rqwjf1bnpr"
	var script_path := "res://scripts/home.gd"

	# In Godot 4 tscn format, unique name is encoded in the
	# node header as part of the groups= attribute with a %
	# prefix — OR as unique_name_in_owner = true property line.
	# The correct format verified from real Godot 4 scenes is:
	# [node name="X" ... groups=["_unique"]]  -- NO, that's groups
	# Actually it is stored as a node property: 
	# unique_name_in_owner = true
	# Let's write it that way and also set layout_mode correctly.

	var tscn := '[gd_scene format=3 uid="' + scene_uid + '"]'
	tscn += "\n\n"
	tscn += '[ext_resource type="Script" uid="' + script_uid
	tscn += '" path="' + script_path + '" id="1_home"]'
	tscn += "\n\n"

	# StyleBoxFlat for ENTER button normal
	tscn += '[sub_resource type="StyleBoxFlat" id="SB_enter"]' + "\n"
	tscn += "bg_color = Color(0.96, 0.57, 0.72, 1)" + "\n"
	tscn += "corner_radius_top_left = 23" + "\n"
	tscn += "corner_radius_top_right = 23" + "\n"
	tscn += "corner_radius_bottom_right = 23" + "\n"
	tscn += "corner_radius_bottom_left = 23" + "\n"
	tscn += "content_margin_left = 24.0" + "\n"
	tscn += "content_margin_top = 10.0" + "\n"
	tscn += "content_margin_right = 24.0" + "\n"
	tscn += "content_margin_bottom = 10.0" + "\n\n"

	# StyleBoxFlat for ENTER button hover
	tscn += '[sub_resource type="StyleBoxFlat" id="SB_hover"]' + "\n"
	tscn += "bg_color = Color(1.0, 0.70, 0.82, 1)" + "\n"
	tscn += "corner_radius_top_left = 23" + "\n"
	tscn += "corner_radius_top_right = 23" + "\n"
	tscn += "corner_radius_bottom_right = 23" + "\n"
	tscn += "corner_radius_bottom_left = 23" + "\n"
	tscn += "content_margin_left = 24.0" + "\n"
	tscn += "content_margin_top = 10.0" + "\n"
	tscn += "content_margin_right = 24.0" + "\n"
	tscn += "content_margin_bottom = 10.0" + "\n\n"

	tscn += _node("Home", "Control", ".")
	tscn += "script = ExtResource(\"1_home\")\n"
	tscn += "anchor_right = 1.0\nanchor_bottom = 1.0\n"
	tscn += "grow_horizontal = 2\ngrow_vertical = 2\n\n"

	tscn += _unode("BgColor", "ColorRect", ".")
	tscn += "anchor_right = 1.0\nanchor_bottom = 1.0\n"
	tscn += "grow_horizontal = 2\ngrow_vertical = 2\n"
	tscn += "mouse_filter = 2\n"
	tscn += "color = Color(0.04, 0.02, 0.10, 1)\n\n"

	tscn += _unode("BgTexture", "TextureRect", ".")
	tscn += "unique_name_in_owner = true\n"
	tscn += "anchor_right = 1.0\nanchor_bottom = 1.0\n"
	tscn += "grow_horizontal = 2\ngrow_vertical = 2\n"
	tscn += "mouse_filter = 2\n"
	tscn += "expand_mode = 1\nstretch_mode = 6\n\n"

	tscn += _unode("BgTint", "ColorRect", ".")
	tscn += "unique_name_in_owner = true\n"
	tscn += "anchor_right = 1.0\nanchor_bottom = 1.0\n"
	tscn += "grow_horizontal = 2\ngrow_vertical = 2\n"
	tscn += "mouse_filter = 2\n"
	tscn += "color = Color(0.0, 0.0, 0.0, 0.45)\n\n"

	# TopBar
	tscn += _node("TopBar", "MarginContainer", ".")
	tscn += "anchor_right = 1.0\noffset_bottom = 56.0\n"
	tscn += "grow_horizontal = 2\nmouse_filter = 2\n"
	tscn += "theme_override_constants/margin_left = 16\n"
	tscn += "theme_override_constants/margin_right = 16\n"
	tscn += "theme_override_constants/margin_top = 8\n"
	tscn += "theme_override_constants/margin_bottom = 8\n\n"

	tscn += _node("TopHBox", "HBoxContainer", "TopBar")
	tscn += "anchor_right = 1.0\nanchor_bottom = 1.0\n"
	tscn += "mouse_filter = 2\n\n"

	tscn += _unode("BtnBack", "Button", "TopBar/TopHBox")
	tscn += "unique_name_in_owner = true\n"
	tscn += "custom_minimum_size = Vector2(90, 36)\n"
	tscn += "size_flags_horizontal = 0\n"
	tscn += 'text = "< Back"' + "\nflat = true\n\n"

	tscn += _node("TopSpacer", "Control", "TopBar/TopHBox")
	tscn += "size_flags_horizontal = 3\nmouse_filter = 2\n\n"

	# MainMargin
	tscn += _node("MainMargin", "MarginContainer", ".")
	tscn += "anchor_right = 1.0\nanchor_bottom = 1.0\n"
	tscn += "offset_top = 56.0\n"
	tscn += "grow_horizontal = 2\ngrow_vertical = 2\n"
	tscn += "mouse_filter = 2\n"
	tscn += "theme_override_constants/margin_left = 0\n"
	tscn += "theme_override_constants/margin_right = 0\n"
	tscn += "theme_override_constants/margin_top = 16\n"
	tscn += "theme_override_constants/margin_bottom = 24\n\n"

	tscn += _node("MainVBox", "VBoxContainer", "MainMargin")
	tscn += "anchor_right = 1.0\nanchor_bottom = 1.0\n"
	tscn += "mouse_filter = 2\n"
	tscn += "theme_override_constants/separation = 24\n\n"

	tscn += _node("LabelTitle", "Label", "MainMargin/MainVBox")
	tscn += "custom_minimum_size = Vector2(0, 48)\n"
	tscn += "size_flags_horizontal = 3\n"
	tscn += "mouse_filter = 2\n"
	tscn += "horizontal_alignment = 1\n"
	tscn += "theme_override_font_sizes/font_size = 22\n"
	tscn += 'text = "Choose Artist\'s Concert Room"' + "\n\n"

	# CarouselStage
	var stage_par := "MainMargin/MainVBox"
	tscn += _unode("CarouselStage", "Control", stage_par)
	tscn += "unique_name_in_owner = true\n"
	tscn += "clip_contents = true\n"
	tscn += "custom_minimum_size = Vector2(0, 200)\n"
	tscn += "size_flags_horizontal = 3\n"
	tscn += "size_flags_vertical = 3\n"
	tscn += "mouse_filter = 2\n\n"

	var row_par := "MainMargin/MainVBox/CarouselStage"
	tscn += _unode("CardRow", "Control", row_par)
	tscn += "unique_name_in_owner = true\n"
	tscn += "mouse_filter = 2\n\n"

	# 5 slots
	var slots := [
		"Slot_BrunoMars","Slot_TaylorSwift",
		"Slot_ArianaGrande","Slot_ChappellRoan",
		"Slot_TheWeeknd"
	]
	for sname : String in slots:
		tscn += _build_slot(sname)

	# NavRow
	tscn += _node("NavRow", "HBoxContainer", "MainMargin/MainVBox")
	tscn += "custom_minimum_size = Vector2(0, 56)\n"
	tscn += "size_flags_horizontal = 3\n"
	tscn += "mouse_filter = 2\n"
	tscn += "alignment = 1\n"
	tscn += "theme_override_constants/separation = 32\n\n"

	tscn += _unode("BtnPrev", "Button", "MainMargin/MainVBox/NavRow")
	tscn += "unique_name_in_owner = true\n"
	tscn += "custom_minimum_size = Vector2(44, 44)\n"
	tscn += 'text = "<"' + "\nflat = true\n\n"

	tscn += _unode("BtnEnter", "Button", "MainMargin/MainVBox/NavRow")
	tscn += "unique_name_in_owner = true\n"
	tscn += "custom_minimum_size = Vector2(180, 46)\n"
	tscn += 'text = "ENTER"' + "\n"
	tscn += "theme_override_font_sizes/font_size = 17\n"
	tscn += "theme_override_colors/font_color = Color(1,1,1,1)\n"
	tscn += 'theme_override_styles/normal = SubResource("SB_enter")' + "\n"
	tscn += 'theme_override_styles/hover = SubResource("SB_hover")' + "\n"
	tscn += 'theme_override_styles/pressed = SubResource("SB_enter")' + "\n\n"

	tscn += _unode("BtnNext", "Button", "MainMargin/MainVBox/NavRow")
	tscn += "unique_name_in_owner = true\n"
	tscn += "custom_minimum_size = Vector2(44, 44)\n"
	tscn += 'text = ">"' + "\nflat = true\n\n"

	# CharOverlay
	tscn += _node("CharOverlay", "Control", ".")
	tscn += "anchor_left = 1.0\nanchor_top = 1.0\n"
	tscn += "anchor_right = 1.0\nanchor_bottom = 1.0\n"
	tscn += "offset_left = -80.0\noffset_top = -120.0\n"
	tscn += "offset_right = 0.0\noffset_bottom = -20.0\n"
	tscn += "grow_horizontal = 0\ngrow_vertical = 0\n"
	tscn += "mouse_filter = 2\n\n"

	tscn += _unode("CharDisplay", "TextureRect", "CharOverlay")
	tscn += "unique_name_in_owner = true\n"
	tscn += "anchor_right = 1.0\nanchor_bottom = 1.0\n"
	tscn += "mouse_filter = 2\n"
	tscn += "expand_mode = 3\nstretch_mode = 6\n"

	var fw := FileAccess.open(
		"res://screens/home.tscn", FileAccess.WRITE
	)
	fw.store_string(tscn)
	fw.close()
	print("home.tscn written OK")

func _node(nm: String, tp: String, par: String) -> String:
	if par == ".":
		return '[node name="' + nm + '" type="' + tp + '"]\n'
	return '[node name="' + nm + '" type="' + tp \
		+ '" parent="' + par + '"]\n'

func _unode(nm: String, tp: String, par: String) -> String:
	# unique nodes: Godot 4 stores unique_name_in_owner as a
	# regular property line directly under the node header
	return _node(nm, tp, par)

func _build_slot(sname: String) -> String:
	var row := "MainMargin/MainVBox/CarouselStage/CardRow"
	var sp := row + "/" + sname
	var card := sp + "/Card"
	var hbox := card + "/CardHBox"
	var right := hbox + "/RightArea"
	var badge := right + "/CrowdBadge"
	var bhbox := badge + "/BadgeHBox"

	var t := _node(sname, "Control", row)
	t += "mouse_filter = 2\n\n"

	t += _node("Card", "PanelContainer", sp)
	t += "custom_minimum_size = Vector2(280, 160)\n\n"

	t += _node("CardHBox", "HBoxContainer", card)
	t += "anchor_right = 1.0\nanchor_bottom = 1.0\n"
	t += "mouse_filter = 2\n"
	t += "theme_override_constants/separation = 0\n\n"

	t += _node("DoorPanel", "Control", hbox)
	t += "custom_minimum_size = Vector2(70, 0)\n"
	t += "size_flags_vertical = 3\nmouse_filter = 2\n\n"

	t += _node("RightArea", "Control", hbox)
	t += "size_flags_horizontal = 3\n"
	t += "size_flags_vertical = 3\nmouse_filter = 2\n\n"

	t += _node("BokehBg", "ColorRect", right)
	t += "anchor_right = 1.0\nanchor_bottom = 1.0\n"
	t += "mouse_filter = 2\n\n"

	t += _node("CrowdBadge", "PanelContainer", right)
	t += "offset_left = 8.0\noffset_top = 8.0\n"
	t += "offset_right = 84.0\noffset_bottom = 32.0\n\n"

	t += _node("BadgeHBox", "HBoxContainer", badge)
	t += "mouse_filter = 2\n"
	t += "theme_override_constants/separation = 4\n\n"

	t += _node("LabelIcon", "Label", bhbox)
	t += 'text = ":)"\n'
	t += "theme_override_font_sizes/font_size = 11\n"
	t += "mouse_filter = 2\n\n"

	t += _node("LabelCrowd", "Label", bhbox)
	t += 'text = "67"\n'
	t += "theme_override_font_sizes/font_size = 11\n"
	t += "theme_override_colors/font_color = Color(1,1,1,1)\n"
	t += "mouse_filter = 2\n\n"

	t += _node("LabelArtist", "Label", right)
	t += "anchor_right = 1.0\nanchor_bottom = 1.0\n"
	t += "offset_left = 12.0\noffset_right = -72.0\n"
	t += "vertical_alignment = 1\n"
	t += "theme_override_font_sizes/font_size = 22\n"
	t += "theme_override_colors/font_color = Color(1,1,1,1)\n"
	t += "mouse_filter = 2\n\n"

	return t
