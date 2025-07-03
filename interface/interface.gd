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

@export var _quiz_container: Control
@export var _quiz_label: Label
@export var _button1: Button
@export var _button2: Button
@export var _button3: Button

var quiz_data = {
	1: {
		"question": "Qual seria a tradução da gíria 'bah tche'?",
		"answers": ["A dog is running", "Cold enough to freeze a dog", "The dog barks at midnight"],
		"correct_answer_index": 1
	},
	2: {
		"question": "Qual é o mascote da Hey Peppers?",
		"answers": ["A talking chimarrão", "A pepper with sunglasses", "A dancing cow"],
		"correct_answer_index": 1
	},
	3: {
		"question": "Qual é a tradução de 'speed'?",
		"answers": ["Laziness", "Speed", "Strength"],
		"correct_answer_index": 1
	},
	4: {
		"question": "Como seria a gíria 'alapuxa tchê' em inglês?",
		"answers": ["Cheers, cowboy!", "Daaang!", "Let’s go now!"],
		"correct_answer_index": 1
	},
	5: {
		"question": "Qual verbo usamos para dizer 'eu sou' em inglês?",
		"answers": ["Have", "Am", "Go"],
		"correct_answer_index": 1
	},
	6: {
		"question": "Qual é a tradução de 'chimarrão'?",
		"answers": ["Cornbread", "Mate (herbal tea)", "Hot chocolate"],
		"correct_answer_index": 1
	},
	7: {
		"question": "Qual é a tradução da expressão 'guri de bombacha'?",
		"answers": ["Lazy cowboy", "Boy in traditional gaucho pants", "Dancer from the south"],
		"correct_answer_index": 1
	},
	8: {
		"question": "Como se diz 'bah, que baita lugar!' em inglês?",
		"answers": ["Oh no, it’s raining again!", "Wow, what an amazing place!", "Look, I forgot my wallet"],
		"correct_answer_index": 1
	},
	9: {
		"question": "O que significa 'matear' em português informal?",
		"answers": ["Fight with someone", "Drink chimarrão", "Ride a horse"],
		"correct_answer_index": 1
	},
	10: {
		"question": "Como se traduz 'tá loco de bom!' para o inglês?",
		"answers": ["I’m going crazy now!", "It’s insanely good!", "It’s a bit boring today"],
		"correct_answer_index": 1
	}
}
var current_question_index = 0
var last_upgrade_type = ""
var last_upgrade_value = 0

func _ready() -> void:
	global.interface = self
	_quiz_container.visible = false

	for _button in get_tree().get_nodes_in_group("choose_button"):
		_button.pressed.connect(_on_button_pressed.bind(_button))

	for _quiz_button in [_button1, _button2, _button3]:
		if _quiz_button:
			_quiz_button.pressed.connect(_on_quiz_button_pressed.bind(_quiz_button))

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
			last_upgrade_type = "vida"
			last_upgrade_value = 50  # Ajuste esse valor conforme o retorno real de WaveManager
			update_health_label(global.player._health)
		"Slot2":
			_wave_manager.apply_card_effect("velocidade")
			last_upgrade_type = "velocidade"
			last_upgrade_value = 25.6  # Ajuste esse valor conforme o retorno real de WaveManager
			update_speed_label(global.player._move_speed)
		"Slot3":
			_wave_manager.apply_card_effect("dano")
			last_upgrade_type = "dano"
			last_upgrade_value = 10  # Ajuste esse valor conforme o retorno real de WaveManager
			update_damage_label(global.player._weapon._attack_damage)
		_:
			print("Slot desconhecido:", slot_name)

	_quiz_container.visible = true
	update_quiz_content()

func _on_quiz_button_pressed(_button: Button) -> void:
	var current_data = quiz_data[current_question_index]
	var selected_answer_index = [_button1, _button2, _button3].find(_button)
	
	if selected_answer_index == current_data["correct_answer_index"]:
		print("Resposta correta")
		apply_bonus_upgrade()
	else:
		print("Resposta errada")

	toggle_waves(true, false)
	_wave_manager._start_new_wave()
	_quiz_container.visible = false

func update_quiz_content() -> void:
	current_question_index = (current_question_index % quiz_data.size()) + 1
	var current_data = quiz_data[current_question_index]
	
	if _quiz_label:
		_quiz_label.text = current_data["question"]
	if _button1 and _button2 and _button3:
		_button1.text = current_data["answers"][0]
		_button2.text = current_data["answers"][1]
		_button3.text = current_data["answers"][2]

func apply_bonus_upgrade() -> void:
	if not global.player:
		return
	
	var bonus_value = last_upgrade_value * 0.5  # 50% do valor do último upgrade
	match last_upgrade_type:
		"vida":
			global.player.increase_max_health(int(bonus_value))
		"velocidade":
			global.player.increase_move_speed(bonus_value)
		"dano":
			global.player.increase_damage(int(bonus_value))

func update_health_label(health: int) -> void:
	_health_label.text = "Health points: %d" % health

func update_speed_label(speed: float) -> void:
	_speed_label.text = "Movement speed: %d" % speed

func update_damage_label(damage: int) -> void:
	_damage_label.text = "Attack damage: %d" % damage

func _on_button_mouse_entered() -> void:
	button_sfx.play()
