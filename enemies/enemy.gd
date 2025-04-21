extends CharacterBody2D
class_name Enemy

var _loading_dash: bool = false
var _is_dashing: bool = false

@export_category("Variables")
@export var _enemy_type: String = "chase"
@export var _move_speed: float = 180.0
@export var _dash_speed: float = 768.0

@export_category("Objects")
@export var _dash_wait_time: Timer
@export var _dash_timer: Timer

func _physics_process(delta: float) -> void:
	if _loading_dash:
		return
	if global.player == null:
		print("personagerm nao encontrado")
		return
		
	var _diretction: Vector2 = global_position.direction_to(global.player.global_position)
	var _distance: float = global_position.distance_to(global.player.global_position)
	
	if _distance <= 16.0:
		
		return
		
	match _enemy_type:
		"chase":
			_chase(_diretction)
		"chase_and_dash":
			_chase_and_dash(_diretction)
	move_and_slide()
	
	
func _chase(_diretction: Vector2) -> void: 
	velocity = _diretction * _move_speed
	
func _chase_and_dash(_diretction: Vector2) -> void: 
	if not _is_dashing:
		velocity = _diretction * _move_speed
	if _is_dashing: 
		velocity = _diretction * _dash_speed


func _on_range_area_body_entered(_body) -> void:
	if _enemy_type != "chase_and_dash":
		return
	if _is_dashing:
		return
	if _body is Player:
		_dash_wait_time.start()
		_loading_dash = true
		

func _on_dash_wait_time_timeout() -> void:
	_loading_dash = false 
	_is_dashing = true
	_dash_timer.start()

func _on_dash_timer_timeout() -> void:
	_is_dashing =  false
