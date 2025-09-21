extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("collect_key"):
			var key_collected = body.collect_key()
			if key_collected:
				queue_free()
				print("Key destroyed!")
