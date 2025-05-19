extends Node

@onready var second_timer: Timer = %second_timer
@onready var hour_timer: Timer = %hour_timer

var second: int = 0
var seconds_past: int = 0
var hour: int = 0
var day: int = 0
var night: bool = false
var is_day: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	second_timer.start()
	if hour > 3 and hour < 17:
		is_day = true
		night = false
	else:
		is_day = false
		night = true

func _on_second_timer_timeout() -> void:
	second += 1
	seconds_past += 1
	second_timer.start()
	if hour > 3 and hour < 17:
		is_day = true
		night = false
	else:
		is_day = false
		night = true
	if second == hour_timer.wait_time:
		hour += 1
		second = 0
		if hour == 24:
			day += 1
			hour = 0

func _process(delta: float) -> void:
	if SaveSystem.game_loaded == true:
		var err = SaveSystem.config.load("res://savegame.cfg")
		if err == OK and SaveSystem.config.get_value("time_stats", "current_time"):
			second = SaveSystem.config.get_value("time_stats", "second")
			hour = SaveSystem.config.get_value("time_stats", "hour")
			
			#seconds_past = SaveSystem.config.get_value("time_stats", "current_time")
			#var seconds_past_calculation = seconds_past
			#hour = 0
			#second = 0
			#for i in range(seconds_past_calculation == 0):
				#if seconds_past_calculation > 60:
					#seconds_past_calculation -= 60
					#hour += 1
				#if seconds_past_calculation < 60:
					#second = seconds_past_calculation
					#seconds_past_calculation = 0
					#
				#seconds_past_calculation = 0
