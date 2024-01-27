extends Node
class_name Core

enum POV {
	Driver,
	BotFront,
	BotRear,
}

static var pov = POV.Driver
static var field: Node3D
static var visionStreamUp: bool = false

@export var drvCam: Camera3D
@export var frontCam: Camera3D
@export var rearCam: Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Set camera
	match pov:
		POV.Driver:
			drvCam.make_current()
		POV.BotFront:
			frontCam.make_current()
		POV.BotRear:
			rearCam.make_current()

static func switch_pov():
	match pov:
		POV.Driver:
			pov = POV.BotFront
		POV.BotFront:
			pov = POV.BotRear
		POV.BotRear:
			pov = POV.Driver
