extends Node2D

var timer: Timer
@onready var timer_label = $TimerLabel

var time_remaining: float


func _ready():
	timer = Timer.new()
	add_child(timer)
	
	time_remaining = GameTracker.get_current_timer()
	
	timer.wait_time = 1.0
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	
	update_timer_display()
	
	GameTracker.game_over_total_fails.connect(_on_total_game_over)

func _on_timer_timeout():
	time_remaining -= 1
	update_timer_display()
	
	if time_remaining <= 0:
		game_over()

func update_timer_display():
	var minutes = floor(time_remaining / 60)
	var seconds = int(time_remaining) % 60
	if timer_label:
		timer_label.text = "%02d:%02d" % [minutes, seconds]
	else:
		print("Time remaining: %02d:%02d" % [minutes, seconds])

func game_over():
	timer.stop()
	GameTracker.increment_failure()

func _on_minigame_won():
	timer.stop()
	GameTracker.increment_game_completion()

func _on_total_game_over():
	timer.stop()
