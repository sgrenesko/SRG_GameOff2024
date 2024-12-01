extends CharacterBody2D

@onready var tilemap = get_parent().get_node("TileMap")
@onready var animated_sprite = $AnimatedSprite2D
@onready var sprite_area = animated_sprite.get_node("Area2D") if animated_sprite else null

var is_moving = false
var target_position = Vector2.ZERO
var move_cooldown = 0.0
const MOVE_DELAY = 0.05  # Adjust this value to control movement speed

func _ready():
	if !animated_sprite:
		push_error("AnimatedSprite2D node not found!")
		return
	if !sprite_area:
		push_error("Area2D node not found!")
		return
		
	var tile_size = Vector2(tilemap.tile_set.tile_size)
	position = tilemap.map_to_local(tilemap.local_to_map(position))
	target_position = position
	
	var collision_shape = sprite_area.get_node("CollisionShape2D")
	if !collision_shape:
		push_error("CollisionShape2D node not found!")
		return
		
	var rectangle_shape = RectangleShape2D.new()
	rectangle_shape.size = Vector2(16, 16)
	collision_shape.shape = rectangle_shape

func _physics_process(delta):
	if is_moving:
		return
		
	move_cooldown -= delta
	if move_cooldown <= 0:
		var input = Vector2.ZERO
		
		if Input.is_action_pressed("up"):
			input.y = -1
		elif Input.is_action_pressed("down"):
			input.y = 1
		elif Input.is_action_pressed("left"):
			input.x = -1
		elif Input.is_action_pressed("right"):
			input.x = 1
		
		if input != Vector2.ZERO:
			target_position = position + (input * 16)
			
			var space_state = get_world_2d().direct_space_state
			var query = PhysicsRayQueryParameters2D.create(position, target_position)
			var result = space_state.intersect_ray(query)
			
			if not result:
				is_moving = true
				position = target_position
				is_moving = false
				move_cooldown = MOVE_DELAY
