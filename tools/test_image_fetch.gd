extends Control

## Standalone Diagnostic Tool: Verify Pollinations AI image loading in Godot
## Run this scene directly (F6) to see if Godot can reach the image server.

func _ready() -> void:
	# 1. Setup UI
	var bg = ColorRect.new()
	bg.color = Color(0.1, 0.1, 0.1)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	
	var label = Label.new()
	label.text = "DIAGNOSTIC: FETCHING IMAGE..."
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	label.offset_top = 50
	add_child(label)
	
	var tex_rect = TextureRect.new()
	tex_rect.custom_minimum_size = Vector2(512, 512)
	tex_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tex_rect.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	add_child(tex_rect)
	
	# 2. Setup Request
	var test_url = "https://image.pollinations.ai/prompt/A%20dog%20singing%20on%20stage.?width=1024&height=1024&nologo=true&seed=1491789620"
	print("[DIAGNOSTIC] Attempting to fetch: ", test_url)
	
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(func(result, code, headers, body):
		print("[DIAGNOSTIC] Result: ", result, " | Code: ", code)
		if code == 200:
			var img = Image.new()
			var err = img.load_jpg_from_buffer(body)
			if err != OK: err = img.load_png_from_buffer(body)
			if err != OK: err = img.load_webp_from_buffer(body)
			
			if err == OK:
				tex_rect.texture = ImageTexture.create_from_image(img)
				label.text = "SUCCESS: IMAGE RENDERED"
				print("[DIAGNOSTIC] Image applied successfully.")
			else:
				label.text = "ERROR: FAILED TO DECODE IMAGE DATA"
				print("[DIAGNOSTIC] Decode error code: ", err)
		else:
			label.text = "ERROR: HTTP CODE " + str(code)
			print("[DIAGNOSTIC] Headers received: ", headers)
	)
	
	var err = http.request(test_url)
	if err != OK:
		label.text = "ERROR: COULD NOT START REQUEST"
		print("[DIAGNOSTIC] Request trigger error: ", err)
