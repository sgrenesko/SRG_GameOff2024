extends AnimatedSprite2D

var current_frame = 0
const TOTAL_FRAMES = 6
var green_frame = 0
const REQUIRED_SPRITES = 5
var buttons_enabled = true
var is_current_sprite = false
@onready var highlight = get_node_or_null("Highlight")

func _ready():
	# Wait one frame to ensure the node is in the scene tree
	await get_tree().process_frame
	
	if not is_in_group("number_sprites"):
		add_to_group("number_sprites")
	
	if highlight:
		highlight.visible = false
	
	var sprites = get_tree().get_nodes_in_group("number_sprites")
	if sprites[0] == self:
		is_current_sprite = true
		if highlight:
			highlight.visible = true
	
	frame = current_frame
	pause()
	
	green_frame = (randi() % (TOTAL_FRAMES - 1)) + 1
	set_sprite_frames_modulate()
	
	print("Frame ", green_frame, " is green")

func _input(event):
	if not buttons_enabled or not is_current_sprite:
		return
		
	if event.is_action_pressed("up"):
		handle_up()
	elif event.is_action_pressed("down"):
		handle_down()

func handle_up():
	current_frame = (current_frame + 1) % TOTAL_FRAMES
	frame = current_frame
	set_sprite_frames_modulate()

func handle_down():
	current_frame = (current_frame - 1)
	if current_frame < 0:
		current_frame = TOTAL_FRAMES - 1
	frame = current_frame
	set_sprite_frames_modulate()

func set_sprite_frames_modulate():
	modulate = Color.WHITE
	if current_frame == green_frame:
		modulate = Color.GREEN
		check_all_sprites_green()
		if is_current_sprite:
			activate_next_sprite()

func activate_next_sprite():
	if not get_tree():
		return
		
	var sprites = get_tree().get_nodes_in_group("number_sprites")
	var current_index = sprites.find(self)
	
	if current_index < sprites.size() - 1:
		is_current_sprite = false
		if highlight:
			highlight.visible = false
		sprites[current_index + 1].is_current_sprite = true
		if sprites[current_index + 1].highlight:
			sprites[current_index + 1].highlight.visible = true

func check_all_sprites_green():
	if not get_tree():
		return
		
	var green_count = 0
	var sprites = get_tree().get_nodes_in_group("number_sprites")
	
	if sprites.size() != REQUIRED_SPRITES:
		push_error("Expected " + str(REQUIRED_SPRITES) + " sprites, but found " + str(sprites.size()))
		return
	
	for sprite in sprites:
		if sprite.frame == sprite.green_frame:
			green_count += 1
	
	print("Green sprites: ", green_count, "/", REQUIRED_SPRITES)
	
	if green_count == REQUIRED_SPRITES:
		print("All sprites are green! Changing scene...")
		for sprite in sprites:
			sprite.buttons_enabled = false
			if sprite.highlight:
				sprite.highlight.visible = false
		GameTracker.increment_game_completion()
