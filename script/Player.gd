extends CharacterBody2D

var default_speed = 100
var current_speed = 100
var player_state

@export var inv: Inv

var bow_equiped = false
var bow_cooldown = true
var arrow = preload("res://scenes/arrow.tscn")
var mouse_location = null

func _ready():
	$RoundTimeoutLabel.visible = false

func _physics_process(delta):
	mouse_location = get_global_mouse_position() - self.position
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif direction.x != 0 or direction.y != 0:
		player_state = "walking"
		
	velocity = direction * current_speed
	move_and_slide()
	
	if Input.is_action_just_pressed("e"):
		if bow_equiped:
			bow_equiped = false
		else:
			bow_equiped = true
	
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	
	if Input.is_action_pressed("left_mouse") and bow_equiped and bow_cooldown:
		bow_cooldown = false
		var arrow_instance = arrow.instantiate()
		arrow_instance.rotation = $Marker2D.rotation
		arrow_instance.global_position = $Marker2D.global_position
		add_child(arrow_instance)
		
		await get_tree().create_timer(0.5).timeout
		bow_cooldown = true
		
	
	play_anim(direction)
	
func play_anim(dir):
	if !bow_equiped:
		current_speed = default_speed
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
		current_speed = default_speed * 0.5
		
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
	

