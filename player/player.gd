extends CharacterBody2D
class_name Player

var _max_health: int 

@export_category("Variables")
@export var _move_speed: float = 256.0
@export_category("Variables")
@export var _health: int = 10

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@export_category("Objects")
@export var _weapon: BaseWeapon
@export var _dust: CPUParticles2D = null
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var sword_pepper: BaseWeapon = $WeaponsManager/Weapon_1/SwordPepper

# Você não precisa mais exportar a interface aqui,
# usaremos o global.interface
# @export var _interface: Interface


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
	if _direction[0] == 0 and _direction[1] == 0:
		anim.stop()
	if _direction[0] >= 0.01 or _direction[1] != 0:
		anim.play('walk_dir')
		sword_pepper.switch_side('dir')
	if _direction[0] < 0:
		anim.play('walk_esq')
		sword_pepper.switch_side('esq')
	
	move_and_slide()

	if _direction:
		_dust.emitting = true
		return
	
	_dust.emitting = false
		
	


func update_health(_type: String, _value: int ) -> void:
	match _type:
		"damage":
			_health -= _value
			if _health <= 0:
				show_game_over()
				queue_free()
		"heal":
			_health += _value
			if _health > _max_health:
				_health = _max_health
		
	global.interface.update_health_label(_health) # <= adicionado aqui
	
func increase_max_health(amount: int) -> void:
	_max_health += amount	
	_health += amount
	global.interface.update_health_label(_health) # <= também aqui


func resethealth() -> void:
	_health = _max_health
	
func show_game_over() -> void:
	var game_over_scene = preload("res://interface/gameOver_screen.tscn")
	var game_over_instance = game_over_scene.instantiate()
	get_tree().get_root().add_child(game_over_instance)
