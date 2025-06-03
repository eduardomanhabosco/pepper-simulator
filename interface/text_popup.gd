extends Label
class_name TextPopup

func update_text(_value: int) -> void:
	text = "-" + str(_value)


func _on_animation_finished(anim_name: StringName) -> void:
	queue_free()
