extends Node2D
class_name WaveManager

const _PIZZA_ENEMY: PackedScene = preload("res://enemies/enemy_pizza.tscn")
const _BURGER_ENEMY: PackedScene = preload("res://enemies/enemy_burger.tscn")

var _waves_dict: Dictionary = {
	1: {
		"wave_time": 20,
		"wave_amount": 1,
		"wave_spawn_cooldown": 4,
		"spots_amount": [3, 6],
		"wave_difficulty": "easy"
	},
	2: {
		"wave_time": 25,
		"wave_amount": 2,
		"wave_spawn_cooldown": 4,
		"spots_amount": [3, 6],
		"wave_difficulty": "medium_to_hard"
	}
}

var _current_wave: int = 1
@export_category("Variables")
@export var _inital_position: Vector2 = Vector2(655,360)
@export_category("Objects")
@export var _wave_timer: Timer
@export var _wave_spawner_timer: Timer
@export var _interface: CanvasLayer = null
@export var _player: Player = null

func _ready() -> void:
	_wave_spawner_timer.start(_waves_dict[_current_wave]["wave_spawn_cooldown"])
	_wave_timer.start(_waves_dict[_current_wave]["wave_time"])
	_interface.update_wave_and_time_label(_current_wave, _wave_timer.time_left)
	_spawn_enemies()


func _on_wave_timer_timeout() -> void:
	_current_wave += 1
	
	if _current_wave > 10:
		print("voce venceu")
		return
	
	#get_tree().paused = true
	_clear_map()
	

func _on_wave_spawn_cooldown_timeout() -> void:
	_spawn_enemies()
	_wave_spawner_timer.start(_waves_dict[_current_wave]["wave_spawn_cooldown"])

func _spawn_enemies() -> void:
	var _amount: int = _waves_dict[_current_wave]["wave_amount"]
	var _spots: Array = []

	for _children in get_children():
		if not _children is Timer:
			_spots.append(_children)
			
	var _spawn_spot: Array = []
	for _i in _amount:
		var _index: int = randi() % _spots.size()
		var _selected_spot: Node2D = _spots[_index]
		_spawn_spot.append(_selected_spot)
		_spots.remove_at(_index)
		
	for _spot in _spawn_spot:
		var _childrens: Array = []
		var _selected_childrens: Array = []
		for _children in _spot.get_children():
			_childrens.append(_children)
			
		var _amount_list: Array = _waves_dict[_current_wave]["spots_amount"]
		var _selected_amount: int = randi_range(_amount_list[0], _amount_list[1])
		for _i in _selected_amount:
			var _index: int = randi() % _childrens.size()
			var _selected_spot: Node2D = _childrens[_index]
			_selected_childrens.append(_selected_spot)
			_childrens.remove_at(_index)
		for _spawner in _selected_childrens:
			_spawn_enemy(_spawner)

func _spawn_enemy(_spawner: Node2D) -> void:
	var _enemy: Enemy = null
	var _randf: float = randf()
	var _dificulty: String = _waves_dict[_current_wave]["wave_difficulty"]
	match _dificulty:
		"easy":
			_enemy = _PIZZA_ENEMY.instantiate()
		"easy_to_medium":
			if _randf <= 0.85:
				_enemy = _PIZZA_ENEMY.instantiate()
			else: 
				_enemy = _BURGER_ENEMY.instantiate()
		"medium":
			if _randf <= 0.6:
				_enemy = _PIZZA_ENEMY.instantiate()
			else: 
				_enemy = _BURGER_ENEMY.instantiate()
		"medium_to_hard":
			if _randf <= 0.25:
				_enemy = _PIZZA_ENEMY.instantiate()
			else: 
				_enemy = _BURGER_ENEMY.instantiate()
		"hard":
			if _randf <= 0.1:
				_enemy = _PIZZA_ENEMY.instantiate()
			else: 
				_enemy = _BURGER_ENEMY.instantiate()

	_enemy.global_position = _spawner.global_position
	get_parent().call_deferred("add_child", _enemy)


func _on_current_time_timer_timeout() -> void:
	_interface.update_wave_and_time_label(_current_wave, _wave_timer.time_left)

func _clear_map() -> void:
	for _chidren in get_parent().get_children():
		if _chidren is Enemy:
			_chidren.queue_free()
	
	_interface.toggle_waves(false, true)
	
func _start_new_wave() -> void:
	_wave_timer.start(_waves_dict[_current_wave]["wave_time"])
	_player.global_position = _inital_position
	_player.resethealth()
