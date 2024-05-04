extends Area2D

var travelled_distance = 0

func _ready():
	set_as_top_level(true)



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
