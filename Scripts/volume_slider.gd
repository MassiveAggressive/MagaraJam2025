extends HSlider

@export var bus_name: String
@export var slider_texture: Texture2D

var bus_index: int
var previous_step: int = 0

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	
	# Slider ayarları - 5 step için
	max_value = 4  # 0, 1, 2, 3, 4 = 5 step
	step = 1       # Her step 1 artacak
	
	# PNG texture'ı uygula
	if slider_texture:
		apply_texture_to_slider()

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	
	# Step değişti mi kontrol et
	var current_step = int(value)
	if current_step != previous_step:
		play_step_sound(current_step)
		previous_step = current_step

func play_step_sound(step: int):
	# Step'e göre ses çal
	match step:
		0:
			SfxManager.play("slider1")
		1:
			SfxManager.play("slider2")
		2:
			SfxManager.play("slider3")
		3:
			SfxManager.play("slider4")
		4:
			SfxManager.play("slider5")

func apply_texture_to_slider():
	var bg_style = StyleBoxTexture.new()
	bg_style.texture = slider_texture
	bg_style.texture_margin_left = 5
	bg_style.texture_margin_right = 5
	bg_style.texture_margin_top = 5
	bg_style.texture_margin_bottom = 5
	
	var fill_style = StyleBoxTexture.new()
	fill_style.texture = slider_texture
	fill_style.texture_margin_left = 5
	fill_style.texture_margin_right = 5
	fill_style.texture_margin_top = 5
	fill_style.texture_margin_bottom = 5
	
	add_theme_stylebox_override("background", bg_style)
	add_theme_stylebox_override("fill", fill_style)
