extends Control

@onready var animation_player = $sceneFade/AnimationPlayer
func _ready() -> void:
	animation_player.play("fadeScreen")

func _on_texture_button_pressed():
	animation_player.play_backwards("fadeScreen")
	await animation_player.animation_finished
	animation_player.play("fadeScreen")
	get_tree().change_scene_to_file("res://scenes/instructions.tscn")
	
