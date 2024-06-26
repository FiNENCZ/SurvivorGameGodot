extends CharacterBody2D

signal health_depleted
signal player_change_health(health)

var default_movement_speed = 100
var current_movement_speed = 100
var attack_speed = 0.5
var attack_damage = 50
var current_health = 200
var max_health = 200

var life_steal = 0
var damage_resistance = 1
var arrow_type = 'normal'
var arrow_number = 1


var player_state

@export var inv: Inv

var bow_equiped = false
var bow_cooldown = true
var arrow = preload("res://scenes/arrow.tscn")
var mouse_location = null

	
func _physics_process(delta):
	mouse_location = get_global_mouse_position() - self.position
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif direction.x != 0 or direction.y != 0:
		player_state = "walking"
		
	velocity = direction * current_movement_speed
	move_and_slide()
	
	if Input.is_action_just_pressed("e"):
		if bow_equiped:
			bow_equiped = false
		else:
			bow_equiped = true
	
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	
	if Input.is_action_pressed("left_mouse") and bow_equiped and bow_cooldown:
		shoot_arrow()
	
	detect_enemy_damage(delta)
	play_anim(direction)
	
func detect_enemy_damage(delta):
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		for mob in overlapping_mobs:
			if mob.has_method("enemy"):
				current_health -= (mob.attack_damage/damage_resistance) * delta
				player_change_health.emit(current_health)
				take_damage_animation()
				if current_health <= 0.0:
					health_depleted.emit()
			
					
func take_damage_animation():
	$AnimatedSprite2D.material.set_shader_parameter("opacity", 0.7);
	$AnimatedSprite2D.material.set_shader_parameter("r", 1.0);
	$AnimatedSprite2D.material.set_shader_parameter("g", 0);
	$AnimatedSprite2D.material.set_shader_parameter("b", 0);
	$AnimatedSprite2D.material.set_shader_parameter("mix_color", 0.7);
	$TakeDamageTimer.start()
	

func reset_shader():
	$AnimatedSprite2D.material.set_shader_parameter("opacity", 1.0);
	$AnimatedSprite2D.material.set_shader_parameter("mix_color", 0);
	
	
func shoot_arrow():
	bow_cooldown = false
	var x_value = 2 if mouse_location.x < 0 else -2
	var y_value = 2 if mouse_location.y < 0 else -2
	
	for i in arrow_number:
		var arrow_instance = arrow.instantiate()
		arrow_instance.arrow_type = arrow_type
		arrow_instance.trigger_life_steal.connect(on_trigger_life_steal)
		arrow_instance.damage = attack_damage
		arrow_instance.rotation = $Marker2D.rotation
		
		if i == 0:
			arrow_instance.global_position = $Marker2D.global_position + Vector2(x_value, y_value)
		else:
			arrow_instance.global_position = $Marker2D.global_position - Vector2(x_value, y_value)
			
		add_child(arrow_instance)
		
	await get_tree().create_timer(attack_speed).timeout
	bow_cooldown = true
	
func play_anim(dir):
	if !bow_equiped:
		current_movement_speed = default_movement_speed
		if player_state == "idle":
			$AnimatedSprite2D.play("idle")
		if player_state == "walking" :
			if dir.y == -1:
				$AnimatedSprite2D.play("n-walk")
			if dir.x == 1:
				$AnimatedSprite2D.play("e-walk")
			if dir.y == 1:
				$AnimatedSprite2D.play("s-walk")
			if dir.x == -1:
				$AnimatedSprite2D.play("w-walk")
				
			if dir.x > 0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("ne-walk")
			if dir.x > 0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("se-walk")
			if dir.x < -0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("sw-walk")
			if dir.x < -0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("nw-walk")
	if bow_equiped:
		current_movement_speed = default_movement_speed * 0.5
		
		if mouse_location.x >= -35 and mouse_location.x <= 35 and mouse_location.y < 0:
			$AnimatedSprite2D.play("n-attack")
		if mouse_location.y >= -35 and mouse_location.y <= 35 and mouse_location.x > 0:
			$AnimatedSprite2D.play("e-attack")
		if mouse_location.x >= -35 and mouse_location.x <= 35 and mouse_location.y > 0:
			$AnimatedSprite2D.play("s-attack")
		if mouse_location.y >= -25 and mouse_location.y <= 35 and mouse_location.x < 0:
			$AnimatedSprite2D.play("w-attack")
			
		if mouse_location.x >= 35 and mouse_location.y <= -35:
			$AnimatedSprite2D.play("ne-attack")
		if mouse_location.x >= 35 and mouse_location.y >= 35:
			$AnimatedSprite2D.play("se-attack")
		if mouse_location.x <= -35 and mouse_location.y >= 35:
			$AnimatedSprite2D.play("sw-attack")
		if mouse_location.x <= -35 and mouse_location.y <= -35:
			$AnimatedSprite2D.play("nw-attack")
			
func player():
	pass

func collect(item):
	inv.insert(item)
	

func _on_take_damage_timer_timeout():
	reset_shader()
	
func on_trigger_life_steal():
	current_health += life_steal
	if current_health > max_health:
		current_health = max_health
	
	player_change_health.emit(current_health)

	
