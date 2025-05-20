extends CanvasLayer
class_name Interface

@export_category("Objects")
@export var _wave_and_time: Label

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
