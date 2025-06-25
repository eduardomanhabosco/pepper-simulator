extends CanvasLayer
class_name Interface

@export_category("Objects")
@export var _wave_and_time: Label
@export var _wave_manager: WaveManager

# Labels de status
@export var _health_label: Label
@export var _speed_label: Label
@export var _damage_label: Label

@onready var upgrade: AudioStreamPlayer = $AudioStreamPlayer
@onready var button_sfx: AudioStreamPlayer = $button_sfx


func _ready() -> void:
	global.interface = self

	for _button in get_tree().get_nodes_in_group("choose_button"):
		_button.pressed.connect(_on_button_pressed.bind(_button))

	if global.player:
		update_health_label(global.player._health)
		update_speed_label(global.player._move_speed)
		if global.player._weapon:
			update_damage_label(global.player._weapon._attack_damage)

func update_wave_and_time_label(_wave: int, _time_remaining: int) -> void:
	_wave_and_time.text = "Wave %d\nTime remaining: %s" % [
		_wave,
		_time_in_seconds(_time_remaining)
	]

func _time_in_seconds(_time: int) -> String:
	var secs = int(_time % 60)
	var mins = int((_time / 60) % 60)
	return "%02d:%02d" % [mins, secs]

func toggle_waves(_show_wave: bool, _show_between: bool) -> void:
	get_tree().paused = _show_between
	$WaveAndTime.visible = _show_wave
	$BetweenWavesContainer.visible = _show_between

func _on_button_pressed(_button: Button) -> void:
	upgrade.play()
	var slot_name := _button.get_parent().name

	match slot_name:
		"Slot1":
			_wave_manager.apply_card_effect("vida")
			update_health_label(global.player._health)
		"Slot2":
			_wave_manager.apply_card_effect("velocidade")
			update_speed_label(global.player._move_speed)
		"Slot3":
			_wave_manager.apply_card_effect("dano")
			update_damage_label(global.player._weapon._attack_damage)
		_:
			print("Slot desconhecido:", slot_name)

	toggle_waves(true, false)
	_wave_manager._start_new_wave()



func update_health_label(health: int) -> void:
	_health_label.text = "Health points: %d" % health

func update_speed_label(speed: float) -> void:
	_speed_label.text = "Movement speed: %d" % speed

func update_damage_label(damage: int) -> void:
	_damage_label.text = "Attack damage: %d" % damage


func _on_button_mouse_entered() -> void:
	button_sfx.play()
