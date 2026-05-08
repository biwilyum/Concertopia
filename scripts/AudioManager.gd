extends Node

# This player is dedicated to background music
var music_player: AudioStreamPlayer

var sounds = {
	"click": load("res://audio/sfx/click.wav"),
	"error": load("res://audio/sfx/error.wav"),
	"generate": load("res://audio/sfx/generate.wav"),
	"hover": load("res://audio/sfx/hover.wav"),
	"reward": load("res://audio/sfx/reward.wav"),
	"success": load("res://audio/sfx/success.wav")
}

func _ready():
	# Initialize the music player once when the game starts
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	# Optional: make music a bit quieter so SFX can be heard
	music_player.volume_db = -5 

# --- FOR SHORT SOUNDS (Hovers, Clicks) ---
func play_sfx(sfx_name: String):
	if sounds.has(sfx_name) and sounds[sfx_name] != null:
		var p = AudioStreamPlayer.new()
		p.stream = sounds[sfx_name]
		add_child(p)
		p.play()
		await p.finished
		p.queue_free()

# --- FOR LONG MUSIC (Artist Rooms) ---
func play_music(music_path: String):
	var stream = load(music_path)
	if stream:
		# If it's already playing this exact song, don't restart it
		if music_player.stream == stream and music_player.playing:
			return
		
		music_player.stop()
		music_player.stream = stream
		music_player.play()
	else:
		print("Music file not found at: ", music_path)
