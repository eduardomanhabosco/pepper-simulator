extends CharacterBody2D
class_name Player

var _max_health: int 
@export_category("Variables")
@export var _move_speed: float = 256.0
@export_category("Variables")
@export var _health: int = 400
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

@export_category("Objects")
@export var _weapon: BaseWeapon
@export var _interface: Interface

func _ready() -> void:
	_max_health = _health
	global.player = self

func _physics_process(delta: float) -> void:
	_move()

func _move() -> void: 
	var _direction: Vector2 = Input.get_vector(
		"move_left", "move_right",
		"move_up", "move_down"
	)
	velocity = _direction * _move_speed
	print(_direction[0])
	if _direction[0] == 0 and _direction[1] == 0:
		anim.stop()
	if _direction[0] >= 0.01 or _direction[1] != 0:
		anim.play('walk_dir')
	if _direction[0] < 0:
		anim.play('walk_esq')
		
	
	move_and_slide()


func update_health(_type: String, _value: int ) -> void:
	match _type:
		"damage":
			_health -= _value
			if _health <= 0:
				queue_free()
		"heal":
			_health += _value
			if _health > _max_health:
				_health = _max_health
	_interface.update_health_ui(_health);
	
func increase_max_health(amount: int) -> void:
	_max_health += amount	
	_health += amount

func resethealth() -> void:
	_health = _max_health
