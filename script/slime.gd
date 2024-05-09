extends CharacterBody2D

var speed = 40
var health = 100
var attack_damage = 50

var player_damage = 50

var dead = false
var player_in_area = false
var player

signal enemy_killed

func _read():
	dead = false

func _physics_process(delta):
	if !dead:
		$DetectionArea/CollisionShape2D.disabled = false
		if player_in_area:
			var direction = global_position.direction_to(player.global_position)
			velocity = direction * speed
			move_and_slide()
			$AnimatedSprite2D.play("move")
		else:
			$AnimatedSprite2D.play("idle")
			
	if dead:
		$DetectionArea/CollisionShape2D.disabled = true
	


func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		player = body


func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false

		
func take_damage(damage):
	health = health - damage
	takeDamageAnimation()
	if health <= 0 and !dead:
		death()
		
func death():
	enemy_killed.emit()
	print("ano, je killed")
	dead = true
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(1).timeout
	queue_free()
	
func takeDamageAnimation():
	$AnimatedSprite2D.material.set_shader_parameter("opacity", 0.7);
	$AnimatedSprite2D.material.set_shader_parameter("r", 1.0);
	$AnimatedSprite2D.material.set_shader_parameter("g", 0);
	$AnimatedSprite2D.material.set_shader_parameter("b", 0);
	$AnimatedSprite2D.material.set_shader_parameter("mix_color", 0.7);
	$TakeDamageTimer.start()
	

func resetShader():
	$AnimatedSprite2D.material.set_shader_parameter("opacity", 1.0);
	$AnimatedSprite2D.material.set_shader_parameter("mix_color", 0);
	
	
func enemy():
	pass
	


func _on_take_damage_timer_timeout():
	resetShader()
