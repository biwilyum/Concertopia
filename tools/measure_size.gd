@tool
extends EditorScript

func _run() -> void:
	var root = "C:/Users/jac23/Desktop/Codes Etc/Concertopia-2/"
	var result = _scan(root)
	var total : int = result[0]
	var count : int = result[1]
	var largest : Array = result[2]
	var mb = float(total) / 1048576.0
	var gb = mb / 1024.0
	largest.sort_custom(func(a, b): return a[0] > b[0])

	var out : String = "=== Project Size ===\n"
	out += "Total files: " + str(count) + "\n"
	out += "Total size:  " + str(snappedf(mb, 0.1)) + " MB"
	out += "  (" + str(snappedf(gb, 0.001)) + " GB)\n\n"
	out += "--- Top 15 largest files ---\n"
	for i in mini(largest.size(), 15):
		var sz = snappedf(float(largest[i][0]) / 1048576.0, 0.01)
		var rel = largest[i][1].replace(root, "")
		out += str(sz) + " MB  " + rel + "\n"

	# Write to absolute path alongside the project
	var out_path = "C:/Users/jac23/Desktop/Codes Etc/Concertopia-2/size_report.txt"
	var f = FileAccess.open(out_path, FileAccess.WRITE)
	if f:
		f.store_string(out)
		f.close()
		print("written to: " + out_path)
	else:
		print("WRITE FAILED")

func _scan(path: String) -> Array:
	var total : int = 0
	var count : int = 0
	var largest : Array = []
	var dir = DirAccess.open(path)
	if dir == null:
		return [total, count, largest]
	dir.list_dir_begin()
	var nm : String = dir.get_next()
	while nm != "":
		if nm != "." and nm != "..":
			var full : String = path + nm
			if dir.current_is_dir():
				var sub = _scan(full + "/")
				total += sub[0]
				count += sub[1]
				largest.append_array(sub[2])
			else:
				var f = FileAccess.open(full, FileAccess.READ)
				if f:
					var sz : int = f.get_length()
					total += sz
					count += 1
					largest.append([sz, full])
					f.close()
		nm = dir.get_next()
	dir.list_dir_end()
	return [total, count, largest]
