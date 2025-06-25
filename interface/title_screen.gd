extends Control
@onready var button_sfx: AudioStreamPlayer = $button_sfx

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

 
func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://management/game_level.tscn")

func _on_htp_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://interface/how_to_play_screen.tscn")

func _on_credits_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://interface/credits_screen.tscn")

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

func _on_go_back_btn_pressed() -> void:
		get_tree().change_scene_to_file("res://interface/title_screen.tscn")


func _on_start_btn_mouse_entered() -> void:
	button_sfx.play()


func _on_htp_btn_mouse_entered() -> void:
	button_sfx.play()


func _on_credits_btn_mouse_entered() -> void:
	button_sfx.play()


func _on_quit_btn_mouse_entered() -> void:
	button_sfx.play()
