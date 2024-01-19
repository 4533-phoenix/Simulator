extends Camera3D

@export var target: Node3D
@export var maxDist: float = 30.0

var defaultFov: float

# Called when the node enters the scene tree for the first time.
func _ready():
	defaultFov = fov


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target:
		look_at(target.position)
		
		var distance = position.distance_to(target.position)
		fov = defaultFov - min(distance * 2, maxDist)
