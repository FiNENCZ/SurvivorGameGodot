extends CharacterBody2D


class_name Enemy

var default_speed = 40
var current_speed = 40
var health = 100
var attack_damage = 50
var mob_modification = "normal"

var count_fire_damage_ticks = 0
var fire_damage_tick = 40
var fire_modification_interval = 3

var player_damage = 50



var dead = false
var player_in_area = false
var player

signal enemy_killed(position)

func _ready():
	dead = false
	set_individual_shader_for_every_instance()

func _physics_process(delta):
	if !dead:
		$DetectionArea/CollisionShape2D.disabled = false
		if player_in_area:
			var direction = global_position.direction_to(player.global_position)
			velocity = direction * current_speed
			move_and_slide()
			$AnimatedSprite2D.play("move")
		else:
			$AnimatedSprite2D.play("idle")
			

func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		player = body


func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false
		
func set_individual_shader_for_every_instance():
	var new_material = $AnimatedSprite2D.material.duplicate()
	$AnimatedSprite2D.material = new_material

		
func take_damage(damage, arrow_type, direction=Vector2.ZERO):
	health = health - damage
	takeDamageAnimation()
	print(arrow_type)
	if health <= 0 and !dead:
		death()
	if arrow_type == "frozen":
		froze_enemy()
	if arrow_type == "fire":
		apply_damage_over_time()
	if arrow_type == "knock":
		apply_knockback(direction)
		
func death():
	enemy_killed.emit(global_position)
	dead = true
	removeEnemyCollisionShape()
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(1).timeout
	queue_free()
	
func removeEnemyCollisionShape():
	var hitbox = $HitBox
	remove_child(hitbox)
	hitbox.queue_free()
	
	var detection_area = $DetectionArea
	remove_child(detection_area)
	detection_area.queue_free()
	
	var collision_shape = $CollisionShape2D
	remove_child(collision_shape)
	collision_shape.queue_free()
	
	
func takeDamageAnimation():
	setDamageShader()
	$TakeDamageTimer.start()
	

func resetShader():
	$AnimatedSprite2D.material.set_shader_parameter("opacity", 1.0);
	$AnimatedSprite2D.material.set_shader_parameter("mix_color", 0);
	


func _on_take_damage_timer_timeout():
	if mob_modification == "normal":
		resetShader()
	elif mob_modification == "frozen":
		setFrozenShader()
	
func froze_enemy():
	current_speed *= 0.6
	mob_modification = "frozen"
	$FrozeEnemyTimer.start()
	

func setDamageShader():
	$AnimatedSprite2D.material.set_shader_parameter("opacity", 0.7);
	$AnimatedSprite2D.material.set_shader_parameter("r", 1.0);
	$AnimatedSprite2D.material.set_shader_parameter("g", 0);
	$AnimatedSprite2D.material.set_shader_parameter("b", 0);
	$AnimatedSprite2D.material.set_shader_parameter("mix_color", 0.7);
	
func setFrozenShader():
	$AnimatedSprite2D.material.set_shader_parameter("opacity", 0.7);
	$AnimatedSprite2D.material.set_shader_parameter("r", 0.1);
	$AnimatedSprite2D.material.set_shader_parameter("g", 0.1);
	$AnimatedSprite2D.material.set_shader_parameter("b", 1);
	$AnimatedSprite2D.material.set_shader_parameter("mix_color", 0.7);

func setFireShader():
	$AnimatedSprite2D.material.set_shader_parameter("opacity", 0.7);
	$AnimatedSprite2D.material.set_shader_parameter("r", 1);
	$AnimatedSprite2D.material.set_shader_parameter("g", 0.5);
	$AnimatedSprite2D.material.set_shader_parameter("b", 0.15);
	$AnimatedSprite2D.material.set_shader_parameter("mix_color", 0.7);


func _on_froze_enemy_timer_timeout():
	current_speed = default_speed
	mob_modification = "normal"
	resetShader()


func _on_fire_enemy_timer_timeout():
	apply_damage_tick()
	
	
func apply_damage_over_time():
	if $FireEnemyTimer.is_stopped() == false:
		$FireEnemyTimer.stop()
	
	count_fire_damage_ticks = 0
	$FireEnemyTimer.start()

# Tato funkce se volá fire_damage_tick_interval
func apply_damage_tick():
	if health > 0:
		health -= fire_damage_tick
		if health <= 0:
			death()
			
	apply_fire_animation()
	
	count_fire_damage_ticks += 1
	if count_fire_damage_ticks >= fire_modification_interval:
		$FireEnemyTimer.stop()

func apply_fire_animation():
	setFireShader()
	await get_tree().create_timer(0.15).timeout
	resetShader()
	
func apply_knockback(direction):
	var knockback_force = 7 # Adjust the force as needed
	position += direction.normalized() * knockback_force
	
	
func enemy():
	pass
	
