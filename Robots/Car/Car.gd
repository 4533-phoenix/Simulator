extends VehicleBody3D

@export var robotCamera: Node3D
@export var worldCamera: Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	worldCamera.global_transform = robotCamera.global_transform

# Called every physics update. 'delta' is the elapsed time since the previous update.
func _physics_process(delta):
	steering = Input.get_axis("Left", "Right") * 0.4 * -1
	engine_force = Input.get_axis("Backward", "Forward") * 750
