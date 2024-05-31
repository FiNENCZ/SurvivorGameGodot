
extends Enemy

signal reproduction_on_contact(pos)

func _ready():
	set_individual_shader_for_every_instance()
	default_speed = 50
	current_speed = default_speed
	health = 225
	
func reproduction_on_player_contact():
	pass


func _on_reproduction_area_body_entered(body):
	if body.has_method("player"):
		print("reproduction_emit_signal")
		emit_signal("reproduction_on_contact", global_position)
		call_deferred("destroy_reproduction_area")
		call_deferred("death")
		
func destroy_reproduction_area():
	if $ReproductionArea != null:
		var detection_area = $ReproductionArea
		remove_child(detection_area)
		detection_area.queue_free()
