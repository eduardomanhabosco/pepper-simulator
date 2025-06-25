extends CanvasLayer
class_name Interface

@export_category("Objects")
@export var _wave_and_time: Label
@export var _wave_manager: WaveManager

# Para os corações
@export var heart_texture: Texture
@export var heart_container: Node  

var max_hearts: int = 0
var current_hearts: int = 0

func _ready() -> void:
	global.interface = self
	for _button in get_tree().get_nodes_in_group("choose_button"):
		_button.pressed.connect(_on_button_pressed.bind(_button))


func update_wave_and_time_label(_wave: int, _time_remaining: int) -> void:
	_wave_and_time.text = (
		"Onda " + str(_wave) + "\n" +
		"Tempo restante - " + _time_in_seconds(_time_remaining)
	)

func _time_in_seconds(_time: int) -> String:
	var _seconds: float = _time % 60
	@warning_ignore("integer_division")
	var _minutes: float = (_time / 60) % 60
	return "%02d:%02d" % [_minutes, _seconds]

func toggle_waves(_wave_state: bool, _waves_container: bool) -> void:
	get_tree().paused = _waves_container
	$WaveAndTime.visible = _wave_state
	$BetweenWavesContainer.visible = _waves_container


func _on_button_pressed(_button: Button) -> void:
	var slot_name := _button.get_parent().name

	match slot_name:
		"Slot1":
			_wave_manager.apply_card_effect("vida")
		"Slot2":
			_wave_manager.apply_card_effect("velocidade")
		"Slot3":
			_wave_manager.apply_card_effect("dano")
		_:
			print("Slot desconhecido: " + slot_name)

	toggle_waves(true, false)
	_wave_manager._start_new_wave()


# -------- Sistema de corações ----------

func update_health_ui(health: int) -> void:
	var hearts_count = int(ceil(health / 50.0))

	if hearts_count > max_hearts:
		for i in range(hearts_count - max_hearts):
			var heart = TextureRect.new()
			heart.texture = heart_texture
			heart_container.add_child(heart)
		max_hearts = hearts_count
	elif hearts_count < max_hearts:
		for i in range(max_hearts - hearts_count):
			if heart_container.get_child_count() > 0:
				heart_container.get_child(heart_container.get_child_count() - 1).queue_free()
		max_hearts = hearts_count
	
	current_hearts = hearts_count
