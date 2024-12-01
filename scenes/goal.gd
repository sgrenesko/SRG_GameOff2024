extends ColorRect

func _ready():
	var area = $Area2D
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):  # Fixed function name
	if body.name == "maze_cursor":
		GameTracker.increment_game_completion()
		
