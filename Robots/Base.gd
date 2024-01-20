extends VehicleBody3D

@export var drvCam: Camera3D
@export var frontCam: Camera3D

@export var robotCamera: Node3D
@export var worldCamera: Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for cam in [worldCamera, frontCam]:
		cam.global_transform = robotCamera.global_transform
