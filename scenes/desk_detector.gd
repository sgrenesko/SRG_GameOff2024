extends Area2D

var player_in_area: bool = false
var player: CharacterBody2D = null
var idle_player: AnimatedSprite2D = null
@onready var interact =$"../../interact_prompt"

func _ready():
	# Connect the area detection signals
	self.connect("body_entered", Callable(self, "_on_body_entered"))
	self.connect("body_exited", Callable(self, "_on_body_exited"))
	
	if interact:
		interact.visible = false
	
	# Get reference to the idle player sprite
	idle_player = get_node("../../IdlePlayer")
	if idle_player:
		idle_player.visible = false  # Initially hide the idle sprite

func _on_body_entered(body: Node) -> void:
	if body.name == "maincharacter" and body is CharacterBody2D:
		player_in_area = true
		player = body
		if player.visible == true:
			interact.visible = true

func _on_body_exited(body: Node) -> void:
	if body.name == "maincharacter" and body is CharacterBody2D:
		player_in_area = false
		player = null

func _process(_delta: float) -> void:
	if player_in_area and player:
		if Input.is_action_just_pressed("interact"):
			player.visible = false
			interact.visible = false
			player.process_mode = Node.PROCESS_MODE_DISABLED  # Prevents the player from moving
			idle_player.visible = true
			await get_tree().create_timer(1).timeout
			MusicManager.stop_music()
			await get_tree().create_timer(1).timeout
			MusicManager.play_music("res://assets/music/Data Corruption v0_8.mp3")
			get_tree().change_scene_to_file("res://scenes/minigames/maze_minigame.tscn")
