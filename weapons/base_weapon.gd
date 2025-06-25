extends Node2D
class_name BaseWeapon

var _is_attacking: bool = false


@export_category("Variavbles")
@export var _attack_damage: int = 22
@export var _attack_cooldown: float

@export_category("Objects")
@export var _attack_timer: Timer
@export var _detection_area: Area2D
@export var _animation: AnimationPlayer

func _on_detection_area_body_entered(_body) -> void:
	if _is_attacking: 
		return
	
	if _body is Enemy:
		_detection_area.set_deferred("monitoring", false)
		_attack_timer.start(_attack_cooldown)
		_animation.play("attack")
		_is_attacking = true


func _on_attack_timer_timeout() -> void:
	_is_attacking = false
	_detection_area.set_deferred("monitoring", true)


func _on_attack_area_body_entered(_body) -> void:
	if _body is Enemy:
		_body.update_health(_attack_damage)
