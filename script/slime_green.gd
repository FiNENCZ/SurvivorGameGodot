extends Enemy


func _ready():
	set_individual_shader_for_every_instance()
	default_speed = 40
	current_speed = default_speed
	health = 150
