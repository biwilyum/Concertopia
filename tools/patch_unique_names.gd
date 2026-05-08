@tool
extends EditorScript

func _run() -> void:
	var path := "res://screens/home.tscn"
	var f := FileAccess.open(path, FileAccess.READ)
	var src := f.get_as_text()
	f.close()

	# Nodes that need unique_name_in_owner = true
	# We patch each [node name="X" ...] line that is missing it
	var targets := [
		"BgTexture",
		"BgTint",
		"BtnBack",
		"CarouselStage",
		"CardRow",
		"BtnPrev",
		"BtnEnter",
		"BtnNext",
		"CharDisplay",
	]

	var lines := src.split("\n")
	var out : PackedStringArray = []

	for i in lines.size():
		var line : String = lines[i]
		var patched := false
		for t : String in targets:
			# match the exact node header line for this target
			var needle := '[node name="' + t + '"'
			if line.begins_with(needle):
				# only add if not already present on next line
				var already := false
				if i + 1 < lines.size():
					already = "unique_name_in_owner" in lines[i + 1]
				out.append(line)
				if not already:
					out.append("unique_name_in_owner = true")
				patched = true
				break
		if not patched:
			out.append(line)

	var fw := FileAccess.open(path, FileAccess.WRITE)
	fw.store_string("\n".join(out))
	fw.close()
	print("patch done — unique names written to tscn")
