extends Node

# Autoload script - name it "MusicManager" in Project Settings

var music_player: AudioStreamPlayer
var current_track: String = ""

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	# Make the music persist across scene changes
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	
func play_music(track_path: String, fade_duration: float = 1.0):
	# If the same track is already playing, do nothing
	if current_track == track_path and music_player.playing:
		return
		
	# Store the new track path
	current_track = track_path
	
	# Load the audio stream
	var stream = load(track_path)
	if stream:
		# Enable looping on the audio stream
		if stream is AudioStreamOggVorbis:
			stream.loop = true
		elif stream is AudioStreamMP3:
			stream.loop = true
		elif stream is AudioStreamWAV:
			stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
			stream.loop_begin = 0
			stream.loop_end = -1  # Loop the entire file
			
		# If music is already playing, fade it out first
		if music_player.playing:
			fade_out(fade_duration)
			await get_tree().create_timer(fade_duration).timeout
			
		music_player.stream = stream
		music_player.play()
		fade_in(fade_duration)

func fade_out(duration: float):
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -80.0, duration)

func fade_in(duration: float):
	music_player.volume_db = -80.0
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", 0.0, duration)

func stop_music(fade_duration: float = 1.0):
	fade_out(fade_duration)
	await get_tree().create_timer(fade_duration).timeout
	music_player.stop()
	current_track = ""
