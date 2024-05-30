extends Node2D

var enemies_per_wave = 5
var wave_countdown_duration = 20
var current_wave_enemies = 0

var slime = preload("res://scenes/slime.tscn")
var slime_red = preload("res://scenes/slime_red.tscn")

var are_emenies_dead = false

func _ready():
	$RoundTimer.start()
	%SkillMenu.increaseAttackSpeed.connect(onIncreseAttackSpeed)
	%SkillMenu.increaseMovementSpeed.connect(onIncreaseMovementSpeed)
	%SkillMenu.increaseAttackDamage.connect(onIncreaseAttackDamage)
	%SkillMenu.increaseMaxHealth.connect(onIncreaseMaxHealth)
	%SkillMenu.increaseDamageResistance.connect(onIncreaseDamageResistance)
	%SkillMenu.addLifeSteal.connect(onAddLifeSteal)
	%SkillMenu.addArrow.connect(onAddArrow)
	%SkillMenu.setFrozenArrows.connect(onSetFrozenArrows)
	%SkillMenu.setFireArrows.connect(onSetFireArrows)
	%SkillMenu.setKnockArrows.connect(onSetKnockArrows)

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
		
		var slime_red_instance = slime_red.instantiate()
		slime_red_instance.enemy_killed.connect(on_enemy_killed)
		
		
		# Umístění nepřátel na mapě tak, aby nebyli příliš blízko hráče
		var spawn_position = find_valid_spawn_position($Player.global_position, 400, 150)
		slime_instance.position = spawn_position
		
		add_child(slime_instance)
		
		slime_red_instance.position = spawn_position
		
		add_child(slime_red_instance)
	

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
	$Player.life_steal += value
	
func onAddArrow():
	if $Player.arrow_number < 3:
		$Player.arrow_number += 1
	
func onIncreaseMaxHealth(value):
	$Player.current_health += value
	$Player.max_health += value
	$Player.get_node("HealthBar").max_value = $Player.max_health
	$Player.get_node("HealthBar").value = $Player.current_health
	$Player.get_node("HealthValue").text = str(int($Player.current_health))
	
func onSetFrozenArrows():
	$Player.arrow_type = 'frozen'
	
func onSetFireArrows():
	$Player.arrow_type = 'fire'
	
func onSetKnockArrows():
	$Player.arrow_type = 'knock'
	
func onIncreaseDamageResistance(value):
	$Player.damage_resistance *= value
	
	
	
	

	
