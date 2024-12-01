extends Node2D

@onready var static_body = $StaticBody2D
@onready var collision_shape = $StaticBody2D/CollisionShape2D
@onready var area = $Area2D
@onready var sprite = $"../../interact_prompt2"
@onready var text = $"../AnimatedSprite2D"
var is_barrier_active = true

func _ready():
	text.visible = false
	text.frame = 0
	# Ensure we have all required nodes
	if !static_body or !collision_shape or !area:
		push_warning("Required nodes not found! Please check the scene structure.")
		return
		
	# Connect the area signals
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exit)

func _input(event):
	if !collision_shape:
		return
		
	# Check if a body is inside the area and the interact key was just pressed
	if event.is_action_pressed("interact") and area.has_overlapping_bodies():
		sprite.visible = false
		text.visible=true
		await get_tree().create_timer(3.0).timeout
		text.visible=false
		await get_tree().create_timer(1.0).timeout
		text.visible=true
		text.frame=1
		await get_tree().create_timer(3.0).timeout
		text.visible=false
		await get_tree().create_timer(1.0).timeout
		text.visible=true
		text.frame=2
		await get_tree().create_timer(3.0).timeout
		text.visible=false
		await get_tree().create_timer(1.0).timeout
		text.visible=true
		text.frame=3
		await get_tree().create_timer(3.0).timeout
		text.visible=false
		await get_tree().create_timer(1.0).timeout
		text.visible=true
		text.frame=4
		await get_tree().create_timer(3.0).timeout
		text.visible=false
		is_barrier_active = false
		collision_shape.set_deferred("disabled", true)
		sprite.visible = false

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Optional: Add visual feedback or sound when player is near
		sprite.visible = true

func _on_body_exit(_body):
	if !collision_shape:
		return
	# Optional: Reset the barrier when the player leaves the area
	# Uncomment the next lines if you want this behavior
	# is_barrier_active = true
	# collision_shape.set_deferred("disabled", false)
