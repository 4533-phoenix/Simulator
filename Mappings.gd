'''
Joystick mappings
'''

extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.add_joy_mapping("030000004f0400000ab1000000000000,T.16000M Joystick,platform:Windows,a:b13,b:b14,x:b12,y:b11,back:b4,guide:b5,start:b6,leftshoulder:b2,rightshoulder:b3,dpup:h0.1,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,leftx:a0,lefty:a1,rightx:a2,righty:a3,lefttrigger:b1,righttrigger:b0,", true)
	print("Fixed mapping")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
