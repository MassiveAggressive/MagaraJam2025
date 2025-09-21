extends StaticBody2D

func _ready():
	# Area2D ekle ve sinyali bağla
	var area = Area2D.new()
	add_child(area)
	
	var collision = CollisionShape2D.new()
	area.add_child(collision)
	
	# CollisionShape2D'ye shape ver (StaticBody2D'nin shape'ini kopyala)
	if has_node("CollisionShape2D"):
		collision.shape = $CollisionShape2D.shape
	
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player hit deadly obstacle!")
		get_tree().change_scene_to_file("res://Scenes/death_menu.tscn")
