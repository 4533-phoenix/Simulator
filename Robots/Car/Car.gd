extends "../Base.gd"

# Called every physics update. 'delta' is the elapsed time since the previous update.
func _physics_process(delta):
	steering = Input.get_axis("Left", "Right") * 0.4 * -1
	engine_force = Input.get_axis("Backward", "Forward") * 750
