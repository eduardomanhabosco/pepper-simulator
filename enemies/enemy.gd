extends CharacterBody2D
class_name Enemy

var _loading_dash: bool = false
var _is_dashing: bool = false
<<<<<<< Updated upstream
<<<<<<< Updated upstream
var _previous_character_position: Vector2 
=======
=======
>>>>>>> Stashed changes
<<<<<<< HEAD
var _previous_character_position: Vector2
=======
var _previous_character_position: Vector2 
>>>>>>> f2662be271868a5faf25b3245df78deacebe8348
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

@export_category("Variables")
@export var _enemy_type: String = "chase"
@export var _move_speed: float = 180.0
@export var _dash_speed: float = 1000
@export var _damage: int = 3
@export var _invincibilty_cooldown: float = 0.5


@export_category("Objects")
@export var _hitbox_area: Area2D
@export var _invincibilty_timer: Timer  
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
		_diretction = global_position.direction_to(_previous_character_position)
		velocity = _diretction * _dash_speed


func _on_range_area_body_entered(_body) -> void:
	if _enemy_type != "chase_and_dash":
		return
	if _is_dashing:
		return
	if _body is Player:
		_previous_character_position = global.player.global_position
		_dash_wait_time.start()
		_loading_dash = true
		

func _on_dash_wait_time_timeout() -> void:
	_loading_dash = false 
	_is_dashing = true
	_dash_timer.start()

func _on_dash_timer_timeout() -> void:
	_is_dashing =  false


func _on_hit_box_area_body_entered(_body) -> void:
	if _body is Player:
		_hitbox_area.set_deferred("monitoring", false)
		_invincibilty_timer.start(_invincibilty_cooldown)
		_body.update_health("damage", _damage)


func _on_invencibilty_timer_timeout() -> void:
		_hitbox_area.set_deferred("monitoring", true)
	
	
