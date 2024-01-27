'''
A semi-realistic swerve drive implementation

Huge thanks go to FRC Team 6244 (Compendium) for their documentation and example code!
I wouldn't have understood this without it.
<https://compendium.readthedocs.io/en/latest/tasks/drivetrains/swerve.html>

TODO:
	- More realistic physics:
		- Breaking
		- Motor spinup
		- Crash damage (you're welcome, Morgan)
	- More configurability
	- ... and more probably
'''

extends "../Base.gd"

@export var frontLeftWheel: VehicleWheel3D
@export var frontRightWheel: VehicleWheel3D
@export var backLeftWheel: VehicleWheel3D
@export var backRightWheel: VehicleWheel3D

static var drvSpeed: float = 250
static var dirSpeed: float = 150
static var breakingForce: float = 1

static var relativeMotion: bool = true
static var relativeMotionOffset: float = 0

var frontLeftDir : float = 0
var frontRightDir: float = 0
var backLeftDir  : float = 0
var backRightDir : float = 0

var startDir: float

class SwerveMod:
	'''
	A somewhat realistic swerve module
	'''
	
	var wheel: VehicleWheel3D
	
	func _init(wheel: VehicleWheel3D):
		self.wheel = wheel
	
	func set_direction(setpoint: float):
		var curr = wheel.steering
		
		wheel.steering = setpoint
		
		#var setpointAngle = Utils.closest_angle(curr, setpoint)
		#var setpointAngleFlipped = Utils.closest_angle(curr, setpoint + 180)
		#
		#if abs(setpointAngle) <= abs(setpointAngleFlipped):
			##wheel.steering = curr + setpointAngle
			#wheel.steering = setpointAngle
			## TODO: Set gain to 1
		#else:
			##wheel.steering = curr + setpointAngleFlipped
			#wheel.steering = setpointAngleFlipped
			## TODO: Set gain to -1
	
	func set_speed(speed: float):
		wheel.engine_force = speed

class SwerveCoord:
	'''
	An ok swerve drive coordinator
	'''
	
	var dir: float
	
	var frontLeft: SwerveMod
	var frontRight: SwerveMod
	var backLeft: SwerveMod
	var backRight: SwerveMod
	
	func _init(frontLeft: SwerveMod, frontRight: SwerveMod, backLeft: SwerveMod, backRight: SwerveMod):
		self.frontLeft = frontLeft
		self.frontRight = frontRight
		self.backLeft = backLeft
		self.backRight = backRight
	
	func translate(direction: float, power: float):
		for mod in [frontLeft, frontRight, backLeft, backRight]:
			mod.set_direction(direction)
		for mod in [frontLeft, frontRight, backLeft, backRight]:
			mod.set_speed(power)
	
	func inplace_turn(power: float):
		# Set swerve module directions to point in a circle
		frontLeft.set_direction(135)
		backLeft.set_direction(45)
		#frontRight.set_direction(-45)
		#backRight.set_direction(-135)
		frontRight.set_direction(-45)
		backRight.set_direction(-135)
		
		for mod in [frontLeft, frontRight, backLeft, backRight]:
			mod.set_speed(power)
	
	func translate_turn(direction: float, translate_power: float, turn_power: float):
		var turnAngle = turn_power * 45
		
		if Utils.closest_angle(direction, 135) >= 90:
			frontLeft.set_direction(direction + turnAngle)
		else:
			frontLeft.set_direction(direction - turnAngle)
		
		if Utils.closest_angle(direction, 225) > 90:
			backLeft.set_direction(direction + turnAngle)
		else:
			backLeft.set_direction(direction - turnAngle)
		
		if Utils.closest_angle(direction, 45) > 90:
			frontRight.set_direction(direction + turnAngle)
		else:
			frontRight.set_direction(direction - turnAngle)
		
		if Utils.closest_angle(direction, 315) >= 90:
			backRight.set_direction(direction + turnAngle)
		else:
			backRight.set_direction(direction - turnAngle)
		
		for mod in [frontLeft, frontRight, backLeft, backRight]:
			mod.set_speed(translate_power)
	
	func set_swerve_drive(direction: float, translate_power: float, turn_power: float):
		dir = direction
		
		if translate_power == 0 and turn_power != 0:
			self.inplace_turn(turn_power)
		else:
			self.translate_turn(direction, translate_power, turn_power)

var coord: SwerveCoord

func _ready():
	startDir = global_rotation.x
	
	coord = SwerveCoord.new(
		SwerveMod.new(frontLeftWheel),
		SwerveMod.new(frontRightWheel),
		SwerveMod.new(backLeftWheel),
		SwerveMod.new(backRightWheel)
	)

func _process(_delta):
	pass #drvCam.global_transform = frontCam.global_transform

func _physics_process(_delta):
	#var translat = Input.get_vector("Backward", "Forward", "Right", "Left", 0.1)
	var fwdBack = Input.get_axis("Backward", "Forward")
	var leftRight = Input.get_axis("Right", "Left")
	#var translat = Input.get_vector("Forward", "Backward", "Left", "Right", 0.1)
	#var translat = Input.get_vector("Left", "Right", "Forward", "Backward", 0.1)
	var rot = Input.get_axis("Rotate Left", "Rotate Right")
	# Speed modifier
	#   1.0 is added because the axis returns something between -1.0 and 1.0.
	#   Adding 1.0 give us a range between 0.0 and 2.0, which is what we want for the speed mofifier.
	#   Otherwise we could have a negative speed mod, which would cause the robot go in reverse.
	var speedMod = Input.get_axis("Adjust Speed (-)", "Adjust Speed (+)") + 1.0
	
	var angle = atan2(leftRight, fwdBack)
	var magnitude = Utils.deadzone(sqrt(pow(leftRight, 2) + pow(fwdBack, 2)), 0.1)
	var twist = Utils.deadzone(rot, 0.1)
	
	# Field-centric controls by subtracting the offset (robot angle)
	#angle -= (global_rotation.x - startDir)
	
	coord.set_swerve_drive(angle, magnitude * (drvSpeed*speedMod), twist * (dirSpeed*speedMod))

## Called every physics update. 'delta' is the elapsed time since the previous update.
#func _physics_process(delta):
	#var translat = Input.get_vector("Left", "Right", "Forward", "Backward")
	#var rot = Input.get_axis("Rotate Left", "Rotate Right")
	#var heading = global_transform.basis.get_euler().y
	#
	#if translat.length() == 0:
		#frontLeftWheel.engine_force = 0
		#frontRightWheel.engine_force = 0
		#backLeftWheel.engine_force = 0
		#backRightWheel.engine_force = 0
#
		#frontLeftWheel.brake = breakingForce
		#frontRightWheel.brake = breakingForce
		#backLeftWheel.brake = breakingForce
		#backRightWheel.brake = breakingForce
	#else:
		#var frontLeftVector = (translat * speed)
		#var frontRightVector = (translat * speed)
		#var backLeftVector = (translat * speed)
		#var backRightVector = (translat * speed)
		#
		#if relativeMotion:
			#frontLeftVector = frontLeftVector.rotated(heading + relativeMotionOffset * PI / 180)
			#frontRightVector = frontRightVector.rotated(heading + relativeMotionOffset * PI / 180)
			#backLeftVector = backLeftVector.rotated(heading + relativeMotionOffset * PI / 180)
			#backRightVector = backRightVector.rotated(heading + relativeMotionOffset * PI / 180)
#
		#frontLeftVector += (Vector2(turn, -turn) * turingSpeed)
		#frontRightVector += (Vector2(turn, turn) * turingSpeed)
		#backLeftVector += (Vector2(-turn, -turn) * turingSpeed)
		#backRightVector += (Vector2(-turn, turn) * turingSpeed)
		#
		#frontLeftVector = frontLeftVector.reflect(Vector2.UP).rotated(PI / 2)
		#frontRightVector = frontRightVector.reflect(Vector2.UP).rotated(PI / 2)
		#backLeftVector = backLeftVector.reflect(Vector2.UP).rotated(PI / 2)
		#backRightVector = backRightVector.reflect(Vector2.UP).rotated(PI / 2)
#
		#frontLeftWheel.steering = frontLeftVector.angle()
		#frontRightWheel.steering = frontRightVector.angle()
		#backLeftWheel.steering = backLeftVector.angle()
		#backRightWheel.steering = backRightVector.angle()
#
		#frontLeftWheel.engine_force = frontLeftVector.length()
		#frontRightWheel.engine_force = frontRightVector.length()
		#backLeftWheel.engine_force = backLeftVector.length()
		#backRightWheel.engine_force = backRightVector.length()
		#
		#lastFrontLeftAngle = frontLeftWheel.steering
		#lastFrontRightAngle = frontRightWheel.steering
		#lastBackLeftAngle = backLeftWheel.steering
		#lastBackRightAngle = backRightWheel.steering
#
		#frontLeftWheel.brake = 0
		#frontRightWheel.brake = 0
		#backLeftWheel.brake = 0
		#backRightWheel.brake = 0
#
	##frontLeftWheel.steering = strafe.angle() + turn
	##frontRightWheel.steering = strafe.angle() + turn
	##backLeftWheel.steering = strafe.angle() + turn
	##backRightWheel.steering = strafe.angle() + turn
	##
	##frontLeftWheel.engine_force = strafe.length()
	##frontRightWheel.engine_force = strafe.length()
	##backLeftWheel.engine_force = strafe.length()
	##backRightWheel.engine_force = strafe.length()
