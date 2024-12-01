extends ColorRect
@onready var anim_player = $"../sceneFade/AnimationPlayer"
@export var auto_fade: bool = true
func _ready() -> void:
	if auto_fade and anim_player:
			anim_player.play("fadeScreen")
