extends Node2D

var enemies_per_wave = 3
var wave_countdown_duration = 20
var current_wave_enemies = 0
var wave_timer

var slime = preload("res://scenes/slime.tscn")

var are_emenies_dead = false

func _ready():
	$RoundTimer.start()
	%SkillMenu.increaseAttackSpeed.connect(onIncreseAttackSpeed)
	%SkillMenu.increaseMovementSpeed.connect(onIncreaseMovementSpeed)
	%SkillMenu.increaseAttackDamage.connect(onIncreaseAttackDamage)

func _process(delta):
	# Aktualizace textu labelu na základě zbývajícího času časovače
	if are_emenies_dead:
		$Player.get_node("RoundTimeoutLabel").visible = true
		$Player.get_node("RoundTimeoutLabel").text = str(round($RoundTimer.time_left))
		
		# Aby se nezobrazovala nula na countdownu
		if $RoundTimer.time_left < 1:
			await get_tree().create_timer(0.5).timeout
			$Player.get_node("RoundTimeoutLabel").visible = false

	
func start_wave():
	current_wave_enemies = enemies_per_wave
	spawn_enemies(current_wave_enemies)

		
func spawn_enemies(amount):
	for i in range(amount):
		var slime_instance = slime.instantiate()
		slime_instance.enemy_killed.connect(on_enemy_killed)
		
		# Umístění nepřátel na mapě tak, aby nebyli příliš blízko hráče
		var spawn_position = find_valid_spawn_position($Player.global_position, 400, 150)
		slime_instance.position = spawn_position
		
		add_child(slime_instance)
	

func find_valid_spawn_position(player_position, max_distance, min_distance):
	var spawn_position = Vector2.ZERO
	var distance = 0
	while distance < min_distance or distance > max_distance:
		spawn_position = Vector2(randf_range(-460, 420), randf_range(-340, 340))
		distance = spawn_position.distance_to(player_position)
	return spawn_position


func _on_round_timer_timeout():
	#$CanvasLayer2/SkillMenu.pause()
	are_emenies_dead = false
	$Player.get_node("RoundTimeoutLabel").visible = false
	$Player.get_node("RoundTimeoutLabel").text = "0"
	start_wave()
	
func on_enemy_killed():
	current_wave_enemies -= 1
	print(current_wave_enemies)
	if current_wave_enemies <= 0:
		are_emenies_dead = true
		$RoundTimer.start()
		
func onIncreseAttackSpeed(value):
	$Player.attack_speed /= value
	
func onIncreaseAttackDamage(value):
	$Player.attack_damage *= value

func onIncreaseMovementSpeed(value):
	$Player.default_movement_speed *= value
	
func onAddLifeSteal(value):
	pass
	
func onAddArrow():
	pass
	
func onIncreaseMaxHealth(value):
	pass
	
func onSetFrozenArrows():
	pass
	
func onSetFireArrows():
	pass
	
func onSetKnockArrow():
	pass
	
func onIncreaseDamageResistance(value):
	pass
	
	
	

	
