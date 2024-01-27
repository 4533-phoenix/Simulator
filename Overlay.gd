extends CanvasLayer

@export var switchPovBtn: Button
#@export var drvCam: Camera3D
#@export var botFrontCam: Camera3D
#@export var botRearCam: Camera3D

var switchPovBtnDown: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if switchPovBtn.button_pressed and !switchPovBtnDown:
		Core.switch_pov()
	
	switchPovBtnDown = switchPovBtn.button_pressed
