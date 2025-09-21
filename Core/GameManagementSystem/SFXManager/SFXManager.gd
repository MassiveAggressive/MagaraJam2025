extends Node

const MAX_PLAYERS := 10
var players: Array = []

var sounds := {
	"button_click": preload("uid://dbfeerkgb75e7"),
}

func _ready():
	# 10 player oluştur
	for i in range(MAX_PLAYERS):
		var p := AudioStreamPlayer.new()
		add_child(p)
		players.append(p)

func play(name: String, volume: float = 0.0, pitch: float = 1.0):
	if not sounds.has(name):
		push_warning("SFX not found: %s" % name)
		return

	for p in players:
		if not p.playing:
			p.stream = sounds[name]
			p.volume_db = volume
			p.pitch_scale = pitch
			p.bus = "Sfx"
			p.play()
			return

	# Eğer tüm playerlar çalıyorsa ilkini değiştir
	players[0].stop()
	players[0].stream = sounds[name]
	players[0].volume_db = volume
	players[0].pitch_scale = pitch
	players[0].bus = "Sfx"
	players[0].play() 
