extends Node2D
var player_in_area: bool = false
@onready var anim_player=$sceneFade/AnimationPlayer
func _ready() -> void:
	anim_player.play("fadeScreen")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
