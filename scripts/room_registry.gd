extends Node
# RoomRegistry — autoload that passes the selected room from home to concert_room.
# Register this as "RoomRegistry" in Project → Project Settings → Autoload.

const ROOMS : Array[Dictionary] = [
	{
		"artist":     "BRUNO\nMARS",
		"genre":      "Pop / R&B",
		"crowd":      142,
		"door_color": Color(0.55, 0.30, 0.10),
		"bg_color1":  Color(0.55, 0.25, 0.05),
		"bg_color2":  Color(0.85, 0.45, 0.10),
		"char_color": Color(0.85, 0.65, 0.20),
		"accent":     Color(1.00, 0.65, 0.15),
	},
	{
		"artist":     "TAYLOR\nSWIFT",
		"genre":      "Pop",
		"crowd":      389,
		"door_color": Color(0.90, 0.35, 0.55),
		"bg_color1":  Color(0.55, 0.05, 0.25),
		"bg_color2":  Color(0.90, 0.30, 0.60),
		"char_color": Color(1.00, 0.80, 0.85),
		"accent":     Color(1.00, 0.55, 0.75),
	},
	{
		"artist":     "ARIANA\nGRANDE",
		"genre":      "Pop / R&B",
		"crowd":      274,
		"door_color": Color(0.55, 0.50, 0.80),
		"bg_color1":  Color(0.20, 0.05, 0.35),
		"bg_color2":  Color(0.55, 0.15, 0.75),
		"char_color": Color(0.80, 0.65, 1.00),
		"accent":     Color(0.75, 0.50, 1.00),
	},
	{
		"artist":     "CHAPPELL\nROAN",
		"genre":      "Pop",
		"crowd":      198,
		"door_color": Color(0.75, 0.38, 0.12),
		"bg_color1":  Color(0.50, 0.18, 0.04),
		"bg_color2":  Color(0.90, 0.45, 0.10),
		"char_color": Color(1.00, 0.75, 0.50),
		"accent":     Color(1.00, 0.55, 0.20),
	},
	{
		"artist":     "THE\nWEEKND",
		"genre":      "R&B",
		"crowd":      311,
		"door_color": Color(0.12, 0.12, 0.18),
		"bg_color1":  Color(0.08, 0.04, 0.20),
		"bg_color2":  Color(0.30, 0.10, 0.50),
		"char_color": Color(0.80, 0.70, 1.00),
		"accent":     Color(0.60, 0.30, 1.00),
	},
]

## The currently selected room — set before navigating to concert_room.tscn
var current_room : Dictionary = {}

## Set room by index (matches home.gd ROOMS array order)
func set_room_by_index(idx : int) -> void:
	if idx >= 0 and idx < ROOMS.size():
		current_room = ROOMS[idx].duplicate()

## Set room by artist name
func set_room_by_name(artist_name : String) -> void:
	for room : Dictionary in ROOMS:
		if room["artist"] == artist_name:
			current_room = room.duplicate()
			return
