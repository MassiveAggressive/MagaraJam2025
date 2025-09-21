extends Node

@export var music_tracks: Array[AudioStream] = [
	#preload("uid://dk583hmbksh6q")
]
  # Inspector'dan ekleyeceğin müzikler
@export var bus_name: String = "Music"              # Music bus'ı

var music_player: AudioStreamPlayer
var current_track_index: int = 0

func _ready():
	# Autoload olduğundan her sahnede instance oluşturulmasına gerek yok
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = bus_name
	music_player.volume_db = 0

	# Inspector'da eklenmiş müzikler varsa ilk parçayı çal
	if music_tracks.size() > 0:
		play_track(0)
	else:
		print("MusicManager: music_tracks listesi boş!")

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

	# Loop ayarı (OGG veya WAV)
	if stream is AudioStreamOggVorbis or stream is AudioStreamWAV:
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
