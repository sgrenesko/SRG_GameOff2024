extends Node

signal all_games_completed
signal timer_updated(new_time)
signal game_over_total_fails

const TOTAL_GAMES_REQUIRED = 60
const INITIAL_TIMER = 60.0
const TIME_DECREASE = 3.0
const GAMES_PER_DIFFICULTY = 6
const MAX_FAILURES = 5

# Add array of minigame scenes - Replace these paths with your actual scene paths
var minigame_scenes = [
	"res://scenes/minigames/maze_minigame.tscn",
	"res://scenes/minigames/code_reveal.tscn",
	"res://scenes/minigames/matching_game.tscn",
	# Add all your minigame scene paths here
]

var current_minigame_index = 0
var completed_games = 0
var current_timer = INITIAL_TIMER
var games_since_decrease = 0
var total_failures = 0

func increment_game_completion():
	completed_games += 1
	games_since_decrease += 1
	print("Minigame completed! Total completed: ", completed_games)
	
	if games_since_decrease >= GAMES_PER_DIFFICULTY:
		decrease_timer()
		games_since_decrease = 0
	
	if completed_games >= TOTAL_GAMES_REQUIRED:
		print("All minigames completed!")
		emit_signal("all_games_completed")
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://scenes/victory.tscn")
	else:
		advance_to_next_minigame()

func advance_to_next_minigame():
	current_minigame_index = (current_minigame_index + 1) % minigame_scenes.size()
	var next_scene = minigame_scenes[current_minigame_index]
	print("Loading next minigame: ", next_scene)  # Debug print
	get_tree().change_scene_to_file(next_scene)

func increment_failure():
	total_failures += 1
	print("Failed attempt! Total failures: ", total_failures)
	
	if total_failures >= MAX_FAILURES:
		print("Too many failures! Game Over!")
		emit_signal("game_over_total_fails")
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://scenes/loser_desert.tscn")
	else:
		advance_to_next_minigame()

func decrease_timer():
	current_timer = max(current_timer - TIME_DECREASE, 5.0)
	emit_signal("timer_updated", current_timer)
	print("Timer decreased to: ", current_timer)

func get_current_timer():
	return current_timer

func reset_progress():
	completed_games = 0
	games_since_decrease = 0
	total_failures = 0
	current_timer = INITIAL_TIMER
	current_minigame_index = 0
	emit_signal("timer_updated", current_timer)
