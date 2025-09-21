class_name camera_shake extends Camera2D

@export var max_shake: float = 100.0
@export var shake_fade: float = 5.0

var _shake_strength: float = 0.0
var shake_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	make_current()
	add_to_group("camera")

func trigger_shake() -> void:
	_shake_strength = max_shake
	print("Shake triggered!")

func _process(delta: float) -> void:
	if _shake_strength > 0:
		_shake_strength = lerp(_shake_strength, 0.0, shake_fade * delta)
		shake_offset = Vector2(
			randf_range(-_shake_strength, _shake_strength),
			randf_range(-_shake_strength, _shake_strength)
		)
	else:
		shake_offset = Vector2.ZERO

	# Sadece offset uygula, global_position ile oynama
	offset = shake_offset
