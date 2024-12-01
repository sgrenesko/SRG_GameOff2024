extends Node2D

func _ready():
	# Create a timer using SceneTree
	await get_tree().create_timer(0.5).timeout
	# Hide this node
	visible = false
