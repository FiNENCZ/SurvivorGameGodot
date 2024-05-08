extends Control

signal increaseAttackDamage(value)
signal increaseMovementSpeed(value)
signal increaseAttackSpeed(value)
signal addLifeSteal(value)
signal addArrow()
signal increaseMaxHealth(value)
signal setFrozenArrows()
signal setFireArrows()
signal setKnockArrow()
signal increaseDamageResistance(value)

func _ready():
	$AnimationPlayer.play("RESET")
	
func _process(delta):
	showSkillMenu()

func start():
	
	visible = false
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")

func stop():
	getSkillsRandomly()
	visible = true
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func showSkillMenu():
	if Input.is_action_just_pressed("x") and get_tree().paused == false:
		stop()
	elif Input.is_action_just_pressed("x") and get_tree().paused == true:
		start()
		
func getSkillsRandomly():
	var num_buttons = %HBoxContainer.get_child_count()

	const num_visible_buttons = 3
	var visible_indices = []

	# Generování náhodných indexů prvků, které budou viditelné
	for i in range(num_visible_buttons):
		var index = randi_range(0, num_buttons - 1)
		while index in visible_indices:
			# Zajištění, že se žádné dva prvky nebudou opakovat
			index = randi_range(0, num_buttons - 1)
		visible_indices.append(index)

	# Nastavení vlastnosti visible pro jednotlivé prvky
	for i in range(num_buttons):
		var button = %HBoxContainer.get_child(i)
		button.visible = i in visible_indices

func _on_btn_skill_attack_speed_pressed():
	emit_signal("increaseAttackSpeed", 1.1)


func _on_btn_skill_attack_damage_pressed():
	emit_signal("increaseAttackDamage", 2)


func _on_btn_skill_movement_speed_pressed():
	emit_signal("increaseMovementSpeed", 1.1)


func _on_btn_skill_life_steal_pressed():
	emit_signal("addLifeSteal", 8)


func _on_btn_skill_two_arrows_pressed():
	emit_signal("addArrow", 1)


func _on_btn_skill_max_health_pressed():
	emit_signal("increaseMaxHealth", 50)


func _on_btn_skill_fire_arrows_pressed():
	emit_signal("setFireArrows")


func _on_btn_skill_frozen_arrows_pressed():
	emit_signal("setFrozenArrows")


func _on_btn_skill_knock_arrows_pressed():
	emit_signal("setKnockArrow")


func _on_btn_skill_damage_resistance_pressed():
	emit_signal("increaseDamageResistance", 1.1)
