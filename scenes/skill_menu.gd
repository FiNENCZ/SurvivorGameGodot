extends Control

signal increaseAttackDamage(value)
signal increaseMovementSpeed(value)
signal increaseAttackSpeed(value)
signal addLifeSteal(value)
signal addArrow()
signal increaseMaxHealth(value)
signal setFrozenArrows()
signal setFireArrows()
signal setKnockArrows()
signal increaseDamageResistance(value)

var skill_button_texture = preload("res://resources/invertory_art/inventory-background.png")



func _ready():
	$AnimationPlayer.play("RESET")
	set_skill_btn_textures()
	

#func _process(delta):
	#showSkillMenu()

func hide_skills():
	visible = false
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")

func show_skills():
	getSkillsRandomly()
	visible = true
	get_tree().paused = true
	$AnimationPlayer.play("blur")

#func showSkillMenu():
	#if Input.is_action_just_pressed("x") and get_tree().paused == false:
		#show_skills()
	#elif Input.is_action_just_pressed("x") and get_tree().paused == true:
		#hide_skills()
		
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

func set_skill_btn_textures():
	var stylebox_texture = StyleBoxTexture.new()
	stylebox_texture.texture = skill_button_texture
	
	var hbox_container = %HBoxContainer
	
	for child in hbox_container.get_children():
		if child is Button:
			child.add_theme_stylebox_override("normal", stylebox_texture)
			child.add_theme_stylebox_override("pressed", stylebox_texture)
			child.add_theme_stylebox_override("hover", stylebox_texture)
			child.add_theme_stylebox_override("disabled", stylebox_texture)
			child.add_theme_stylebox_override("focused", stylebox_texture)
			
	

func _on_btn_skill_attack_speed_pressed():
	emit_signal("increaseAttackSpeed", 1.1)
	hide_skills()


func _on_btn_skill_attack_damage_pressed():
	emit_signal("increaseAttackDamage", 2)
	hide_skills()


func _on_btn_skill_movement_speed_pressed():
	emit_signal("increaseMovementSpeed", 1.1)
	hide_skills()


func _on_btn_skill_life_steal_pressed():
	emit_signal("addLifeSteal", 3)
	hide_skills()


func _on_btn_skill_two_arrows_pressed():
	emit_signal("addArrow")
	hide_skills()
	var button = %btnSkillTwoArrows
	%HBoxContainer.remove_child(button)
	button.queue_free()


func _on_btn_skill_max_health_pressed():
	emit_signal("increaseMaxHealth", 50)
	hide_skills()


func _on_btn_skill_fire_arrows_pressed():
	emit_signal("setFireArrows")
	hide_skills()


func _on_btn_skill_frozen_arrows_pressed():
	emit_signal("setFrozenArrows")
	hide_skills()


func _on_btn_skill_knock_arrows_pressed():
	emit_signal("setKnockArrows")
	hide_skills()


func _on_btn_skill_damage_resistance_pressed():
	emit_signal("increaseDamageResistance", 1.1)
	hide_skills()
