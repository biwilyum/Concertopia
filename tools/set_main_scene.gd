@tool
extends EditorScript

func _run() -> void:
	ProjectSettings.set_setting("application/run/main_scene", "res://screens/bootstrap.tscn")
	ProjectSettings.save()
