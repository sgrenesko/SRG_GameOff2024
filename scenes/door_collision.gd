# DetectionArea.gd
extends Area2D

var player_in_area: bool = false
@export var target_scene: PackedScene
@export var auto_fade: bool = true

@onready var anim_player = $"../sceneFade/AnimationPlayer"
@onready var sprite = $"../interact_prompt"  # Reference to the AnimatedSprite2D node

signal player_interacted

func _ready() -> void:
	# Connect the signals to the respective methods
	self.connect("body_entered", Callable(self, "_on_body_entered"))
	self.connect("body_exited", Callable(self, "_on_body_exited"))
	
	# First check if we have the animation player before trying to use it
	if auto_fade and anim_player:
		anim_player.play("fadeScreen")

	# Check if sprite exists before trying to set its visibility
	if sprite:
		sprite.visible = false
	else:
		push_warning("AnimatedSprite2D node not found at path '../AnimatedSprite2D'")

func _on_body_entered(body: Node) -> void:
	if body.name == "Player" and body is CharacterBody2D:
		player_in_area = true
		if sprite:  # Check if sprite exists
			sprite.visible = true

func _on_body_exited(body: Node) -> void:
	if body.name == "Player" and body is CharacterBody2D:
		player_in_area = false
		if sprite:  # Check if sprite exists
			sprite.visible = false

func _process(delta: float) -> void:
	if player_in_area:
		if Input.is_action_just_pressed("interact"):
			emit_signal("player_interacted")
			if target_scene:
				get_tree().change_scene_to_packed(target_scene)
