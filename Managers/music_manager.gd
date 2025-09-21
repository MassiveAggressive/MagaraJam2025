# MusicManager.gd
extends Node

@export var music_tracks: Array[AudioStream] = [
	preload("res://audio/SlowMusic.wav"),  # Level1 ve Level2 için (index 0)
	preload("res://audio/Test1 (mastered).mp3")  # Main Menu için (index 1)
]

@export var bus_name: String = "Music"              

var music_player: AudioStreamPlayer
var current_track_index: int = 0

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = bus_name
	music_player.volume_db = 0  

	# Varsayılan olarak Test1 çal (Main Menu için)
	play_track(1)  # Test1'i çal

func _process(delta):
	# AudioStreamWAV için loop kontrolü
	if not music_player.playing and music_player.stream is AudioStreamWAV:
		music_player.play()

func play_track(index: int):
	if music_tracks.is_empty():
		push_warning("MusicManager: Müzik listesi boş.")
		return

	if index < 0 or index >= music_tracks.size():
		push_warning("MusicManager: Geçersiz indeks %d. 0. parça çalınıyor." % index)
		index = 0

	current_track_index = index
	var stream = music_tracks[current_track_index]
	music_player.stream = stream

	# Loop ayarla - sadece AudioStreamOggVorbis için
	if stream is AudioStreamOggVorbis:
		stream.loop = true

	music_player.play()

func stop():
	if music_player.playing:
		music_player.stop()

func next_track():
	if music_tracks.size() <= 1:
		return
	play_track((current_track_index + 1) % music_tracks.size())

func set_volume_db(volume_db: float):
	music_player.volume_db = volume_db
