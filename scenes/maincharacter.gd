extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -150.0
var sideTrack=0;#Used to have player face the direction they were moving while idling

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	#Character movement logic
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#Directional logic for what sprites to show when, left right, jump, and idle REPLACE WITH BETTER LOGIC LATER
	#JUMP
	
	#RIGHT WALK
	if Input.is_action_pressed("right"):
		$AnimatedSprite2D.play("WalkRight")
		sideTrack=0
	
	#LEFT WALK
	else: if Input.is_action_pressed("left"):
		$AnimatedSprite2D.play("WalkLeft")
		sideTrack=1
	
	#IDLE
	else: if Input.is_anything_pressed()==false:
		if sideTrack==0:
			$AnimatedSprite2D.play("IdleRight")
		else: if sideTrack==1:
			$AnimatedSprite2D.play("IdleLeft")
	Input.is_key_pressed(KEY_E)
	move_and_slide()
