extends CanvasLayer
class_name Interface

@export_category("Objects")
@export var _wave_and_time: Label
@export var _wave_manager: WaveManager

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
		toggle_waves(true, false)
		_wave_manager._start_new_wave()
	
