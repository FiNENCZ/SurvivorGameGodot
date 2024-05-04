extends Node2D

var enemies_per_wave = 3
var wave_countdown_duration = 20
var current_wave_enemies = 0
var wave_timer

var slime = preload("res://scenes/slime.tscn")

func _ready():
	start_wave()
	$RoundTimer.start()

func start_wave():
	current_wave_enemies = enemies_per_wave
	spawn_enemies(current_wave_enemies)

func spawn_enemies(amount):
	
	for i in range(amount):
		var slime_instance = slime.instantiate()
		# Umístění nepřátel na mapě
		var spawn_position = Vector2(randf_range(-200, 200), randf_range(-200, 200))
		print(spawn_position)
		slime_instance.position = spawn_position
		add_child(slime_instance)


func _on_round_timer_timeout():
	print("start")
	start_wave()
