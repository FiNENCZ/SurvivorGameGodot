extends Node2D

var enemies_per_wave = 5
var wave_countdown_duration = 20
var current_wave_enemies = 0

var current_round_index = 0

var are_emenies_dead = false
var round_functions = [round_one, round_two, round_three, round_four, round_five]

var enemy_scenes = {
	"slime_green": preload("res://scenes/slime_green.tscn"),
	"slime_red": preload("res://scenes/slime_red.tscn"),
	"slime_grey": preload("res://scenes/slime_grey.tscn"),
	"slime_purple": preload("res://scenes/slime_purple.tscn")
}

var enemy_signal_function_name = {
	"slime_green": "on_enemy_killed",
	"slime_red": "on_enemy_killed",
	"slime_grey": "on_slime_grey_killed",
	"slime_yellow": "on_enemy_killed",
	"slime_purple": "on_enemy_killed"
}

var enemy_reproduction_signal = {
	"slime_green": false,
	"slime_red": false,
	"slime_grey": false,
	"slime_yellow": false,
	"slime_purple": true
}

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
	if current_round_index < round_functions.size():
		round_functions[current_round_index].call()
		current_round_index += 1
	else:
		print("All rounds completed")
	
func getSlimeParameters(slime_name):
	return [enemy_scenes.get(slime_name, null), enemy_signal_function_name.get(slime_name, null), enemy_reproduction_signal.get(slime_name, false)]

		
func spawn_enemies(amount):
	for i in range(amount):
		var spawn_position = find_valid_spawn_position($Player.global_position, 400, 150)
		spawn_new_slime(spawn_position, getSlimeParameters("slime_grey"))

func round_one():
	for i in range(8):
		var spawn_position = find_valid_spawn_position($Player.global_position, 400, 150)
		spawn_new_slime(spawn_position, getSlimeParameters("slime_purple"))

func round_two():
	for i in range(5):
		var spawn_position = find_valid_spawn_position($Player.global_position, 400, 150)
		spawn_new_slime(spawn_position, getSlimeParameters("slime_green"))
	for i in range(6):
		var spawn_position = find_valid_spawn_position($Player.global_position, 400, 150)
		spawn_new_slime(spawn_position, getSlimeParameters("slime_red"))
		
func round_three():
	for i in range(8):
		var spawn_position = find_valid_spawn_position($Player.global_position, 400, 150)
		spawn_new_slime(spawn_position, getSlimeParameters("slime_green"))
	await get_tree().create_timer(2.5).timeout
	for i in range(10):
		var spawn_position = find_valid_spawn_position($Player.global_position, 400, 150)
		spawn_new_slime(spawn_position, getSlimeParameters("slime_red"))
		
func round_four():
	for i in range(12):
		var spawn_position = find_valid_spawn_position($Player.global_position, 400, 150)
		spawn_new_slime(spawn_position, getSlimeParameters("slime_green"))
	await get_tree().create_timer(1).timeout
	for i in range(6):
		var spawn_position = find_valid_spawn_position($Player.global_position, 400, 150)
		spawn_new_slime(spawn_position, getSlimeParameters("slime_grey"))
		
func round_five():
	for i in range(12):
		var spawn_position = find_valid_spawn_position($Player.global_position, 400, 150)
		spawn_new_slime(spawn_position, getSlimeParameters("slime_red"))
	await get_tree().create_timer(1).timeout
	for i in range(10):
		var spawn_position = find_valid_spawn_position($Player.global_position, 400, 150)
		spawn_new_slime(spawn_position, getSlimeParameters("slime_green"))
	await get_tree().create_timer(1).timeout
	for i in range(8):
		var spawn_position = find_valid_spawn_position($Player.global_position, 400, 150)
		spawn_new_slime(spawn_position, getSlimeParameters("slime_grey"))
	


func on_slime_grey_killed(klled_slime_grey_position):
	current_wave_enemies -= 1
	spawn_four_enemies_close_together(klled_slime_grey_position, "slime_green")
		
func on_reproduction_enemy_contact(spawn_position):
	spawn_four_enemies_close_together(spawn_position, "slime_red")
	
func spawn_four_enemies_close_together(spawn_position, slime_name):
	for i in range(4):
		var new_slime_position = spawn_position
		if i == 0:
			new_slime_position.x += 10
		if i == 1:
			new_slime_position.x -= 10
		if i == 2:
			new_slime_position.y += 10
		if i == 3:
			new_slime_position.y -= 10
		
		call_deferred("spawn_new_slime", new_slime_position, getSlimeParameters(slime_name))

func spawn_new_slime(position, enemy_parameters):
	var enemy_scene = enemy_parameters[0]
	var signal_function_name = enemy_parameters[1]
	var reproduction_on_enemy_contact = enemy_parameters[2]
	
	if enemy_scene != null:
		var enemy_instance = enemy_scene.instantiate()
		var signal_callable = Callable(self, signal_function_name)
		enemy_instance.enemy_killed.connect(signal_callable)
		if reproduction_on_enemy_contact:
			enemy_instance.reproduction_on_contact.connect(on_reproduction_enemy_contact)
		enemy_instance.position = position
		add_child(enemy_instance)
		current_wave_enemies += 1
	
	
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
	
func on_enemy_killed(klled_enemy_position):
	current_wave_enemies -= 1
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
	
	
	
	

	
