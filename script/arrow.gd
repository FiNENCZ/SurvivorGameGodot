extends Area2D

signal player_deal_damage(damage)
signal trigger_life_steal()

var travelled_distance = 0
var damage
var arrow_type = "normal"
var direction = Vector2.ZERO

func _ready():
	set_as_top_level(true)
	direction = Vector2.RIGHT.rotated(rotation)



func _physics_process(delta):
	const SPEED = 300
	const RANGE = 350
	
	position += (Vector2.RIGHT*SPEED).rotated(rotation) * delta
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()
	


func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
	
func arrow_deal_damage():
	pass

func _on_body_entered(body):
	if body.has_method("enemy"):
		queue_free()
		body.take_damage(damage, arrow_type, direction)
		emit_signal("trigger_life_steal")
