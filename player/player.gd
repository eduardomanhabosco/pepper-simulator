extends CharacterBody2D
class_name Player

@export_category("Variables")
@export var _move_speed: float = 256.0
@export var _health: int = 20

func _ready() -> void:
	global.player = self

func _physics_process(delta: float) -> void: 
	_move()
	
	
func _move() -> void: 
	var _direction: Vector2 = Input.get_vector(
		"move_left", "move_right",
		"move_up", "move_down"
	)
	velocity = _direction * _move_speed
	move_and_slide()

func update_health(_type: String, _value: int ) -> void:
	match _type:
		"damage":
			_health -= _value
			if _health <= 0:
				print("dano")
				queue_free()
		"heal":
			pass
	
