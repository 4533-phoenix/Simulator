extends CanvasLayer

@export var btn: Button
#@export var drvCam: Camera3D
#@export var botFrontCam: Camera3D
#@export var botRearCam: Camera3D

var btnDown: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if btn.button_pressed and !btnDown:
		Core.switch_pov()
		btnDown = true
	
	if !btn.button_pressed and btnDown:
		btnDown = false
		

