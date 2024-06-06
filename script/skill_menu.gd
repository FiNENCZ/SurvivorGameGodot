extends Control

signal increase_attack_damage(value)
signal increase_movement_speed(value)
signal increase_attack_speed(value)
signal add_life_steal(value)
signal add_arrow()
signal increase_max_health(value)
signal set_frozen_arrows()
signal set_fire_arrows()
signal set_knock_arrows()
signal increase_damage_resistance(value)

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

	# Generate random indexes of elements that will be visible
	for i in range(num_visible_buttons):
		var index = randi_range(0, num_buttons - 1)
		while index in visible_indices:
			# Ensuring that no two elements are repeated
			index = randi_range(0, num_buttons - 1)
		visible_indices.append(index)

	# Setting the visible property for individual elements
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
	emit_signal("increase_attack_speed", 1.1)
	hide_skills()


func _on_btn_skill_attack_damage_pressed():
	emit_signal("increase_attack_damage", 1.1)
	hide_skills()


func _on_btn_skill_movement_speed_pressed():
	emit_signal("increase_movement_speed", 1.1)
	hide_skills()


func _on_btn_skill_life_steal_pressed():
	emit_signal("add_life_steal", 2)
	hide_skills()


func _on_btn_skill_two_arrows_pressed():
	emit_signal("add_arrow")
	hide_skills()
	var button = %btnSkillTwoArrows
	%HBoxContainer.remove_child(button)
	button.queue_free()


func _on_btn_skill_max_health_pressed():
	emit_signal("increase_max_health", 50)
	hide_skills()


func _on_btn_skill_fire_arrows_pressed():
	emit_signal("set_fire_arrows")
	hide_skills()


func _on_btn_skill_frozen_arrows_pressed():
	emit_signal("set_frozen_arrows")
	hide_skills()


func _on_btn_skill_knock_arrows_pressed():
	emit_signal("set_knock_arrows")
	hide_skills()


func _on_btn_skill_damage_resistance_pressed():
	emit_signal("increase_damage_resistance", 1.1)
	hide_skills()
