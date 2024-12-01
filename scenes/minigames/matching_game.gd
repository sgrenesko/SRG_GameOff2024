extends Node2D

var target_sprites: Array[Sprite2D] = []
var animated_sprites: Array[AnimatedSprite2D] = []
var current_sprite_index: int = 0
var current_target_index: int = 0
var completed_targets: Array[Sprite2D] = []
@export var next_scene: String = "res://scenes/minigames/maze_minigame.tscn"  # Set this in the inspector

func _ready():
	z_index = -1
	
	var sprite_nodes = get_tree().get_nodes_in_group("target_sprites")
	for node in sprite_nodes:
		if node is Sprite2D:
			target_sprites.append(node)
	
	var anim_nodes = get_tree().get_nodes_in_group("animated_sprites")
	for node in anim_nodes:
		if node is AnimatedSprite2D:
			animated_sprites.append(node)
	
	if animated_sprites.size() > 0:
		assign_random_unique_frames()
		update_sprite_colors()

func assign_random_unique_frames() -> void:
	var available_frames = range(6)
	available_frames.shuffle()
	
	for i in animated_sprites.size():
		animated_sprites[i].frame = available_frames[i]

func is_correct_match() -> bool:
	var current_sprite = animated_sprites[current_sprite_index]
	return current_sprite.frame == current_target_index

func check_puzzle_complete() -> void:
	if completed_targets.size() == target_sprites.size():
		# Optional: Add a small delay or animation before scene change
		GameTracker.increment_game_completion()

func _input(event: InputEvent) -> void:
	if current_target_index < target_sprites.size():
		if event.is_action_pressed("right"):
			current_sprite_index = (current_sprite_index + 1) % animated_sprites.size()
			update_sprite_colors()
		elif event.is_action_pressed("left"):
			current_sprite_index = (current_sprite_index - 1) if current_sprite_index > 0 else animated_sprites.size() - 1
			update_sprite_colors()
		elif event.is_action_pressed("interact") and not target_sprites[current_target_index] in completed_targets:
			if is_correct_match():
				var current_target = target_sprites[current_target_index]
				current_target.modulate = Color(0.0, 1.0, 0.0, 1.0)  # Green
				completed_targets.append(current_target)
				current_target_index += 1
				check_puzzle_complete()  # Check if puzzle is complete after successful match
			else:
				var current_target = target_sprites[current_target_index]
				current_target.modulate = Color(1.0, 0.0, 0.0, 1.0)  # Red
				await get_tree().create_timer(0.2).timeout
				current_target.modulate = Color(1.0, 1.0, 1.0, 1.0)  # Back to normal

func update_sprite_colors() -> void:
	for i in animated_sprites.size():
		if i == current_sprite_index:
			animated_sprites[i].modulate = Color(0.7, 0.7, 0.7, 1.0)
		else:
			animated_sprites[i].modulate = Color(0.4, 0.4, 0.4, 1.0)

func _process(_delta):
	queue_redraw()

func get_sprite_edge_point(sprite_pos: Vector2, sprite_size: Vector2, target_pos: Vector2) -> Vector2:
	var center = sprite_pos
	var direction = (target_pos - center).normalized()
	var half_width = sprite_size.x / 2
	var half_height = sprite_size.y / 2
	
	var scale_x = abs(half_width / direction.x) if direction.x != 0 else INF
	var scale_y = abs(half_height / direction.y) if direction.y != 0 else INF
	var scale = min(scale_x, scale_y)
	
	return center + direction * scale

func _draw():
	if animated_sprites.size() > 0 and current_target_index < target_sprites.size():
		var current_sprite = animated_sprites[current_sprite_index]
		var current_target = target_sprites[current_target_index]
		
		var pos1 = current_target.global_position
		var pos2 = current_sprite.global_position
		
		var size1 = current_target.texture.get_size()
		var size2 = current_sprite.sprite_frames.get_frame_texture(current_sprite.animation, current_sprite.frame).get_size()
		
		var start_point = get_sprite_edge_point(pos1, size1, pos2)
		var end_point = get_sprite_edge_point(pos2, size2, start_point)
		
		draw_line(to_local(start_point), to_local(end_point), Color.WHITE, 2.0)
