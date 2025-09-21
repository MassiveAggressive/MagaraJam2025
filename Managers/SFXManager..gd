extends Node

const MAX_PLAYERS := 10
var players: Array = []

var sounds := {
	"button_click": preload("res://audio/MenuClick.wav"),
	"slider1": preload("res://audio/SFXPack/Ui/Slider1.wav"),
	"slider2": preload("res://audio/SFXPack/Ui/Slider2.wav"),
	"slider3": preload("res://audio/SFXPack/Ui/Slider3.wav"),
	"slider4": preload("res://audio/SFXPack/Ui/Slider4.wav"),
	"slider5": preload("res://audio/SFXPack/Ui/Slider5.wav"),
	"scissors1": preload("res://audio/SFXPack/Player/Scissors1.wav"),
	"scissors2": preload("res://audio/SFXPack/Player/Scissors2.wav"),
	"scissors3": preload("res://audio/SFXPack/Player/Scissors3.wav"),
	"scissors4": preload("res://audio/SFXPack/Player/Scissors4.wav"),
	"scissorscombo": preload("res://audio/SFXPack/Player/ScissorsCombo.wav"),
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
