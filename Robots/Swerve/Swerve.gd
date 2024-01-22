extends "../Base.gd"

@export var frontLeftWheel: VehicleWheel3D
@export var frontRightWheel: VehicleWheel3D
@export var backLeftWheel: VehicleWheel3D
@export var backRightWheel: VehicleWheel3D

@export var speed: float = 100
@export var turingSpeed: float = 75
@export var breakingForce: float = 1

@export var relativeMotion: bool = true
@export var relativeMotionOffset: float = 0

var lastFrontLeftAngle = 0;
var lastFrontRightAngle = 0;
var lastBackLeftAngle = 0;
var lastBackRightAngle = 0;

# Called every physics update. 'delta' is the elapsed time since the previous update.
func _physics_process(delta):
	var strafe = Input.get_vector("Left", "Right", "Forward", "Backward")
	var turn = Input.get_axis("Rotate Left", "Rotate Right")
	var heading = global_transform.basis.get_euler().y
	
	if strafe.length() == 0 and turn == 0:
		frontLeftWheel.steering = lastFrontLeftAngle
		frontRightWheel.steering = lastFrontRightAngle
		backLeftWheel.steering = lastBackLeftAngle
		backRightWheel.steering = lastBackRightAngle

		frontLeftWheel.engine_force = 0
		frontRightWheel.engine_force = 0
		backLeftWheel.engine_force = 0
		backRightWheel.engine_force = 0

		frontLeftWheel.brake = breakingForce
		frontRightWheel.brake = breakingForce
		backLeftWheel.brake = breakingForce
		backRightWheel.brake = breakingForce
	else:
		var frontLeftVector = (strafe * speed)
		var frontRightVector = (strafe * speed)
		var backLeftVector = (strafe * speed)
		var backRightVector = (strafe * speed)
		
		if relativeMotion:
			frontLeftVector = frontLeftVector.rotated(heading + relativeMotionOffset * PI / 180)
			frontRightVector = frontRightVector.rotated(heading + relativeMotionOffset * PI / 180)
			backLeftVector = backLeftVector.rotated(heading + relativeMotionOffset * PI / 180)
			backRightVector = backRightVector.rotated(heading + relativeMotionOffset * PI / 180)

		frontLeftVector += (Vector2(turn, -turn) * turingSpeed)
		frontRightVector += (Vector2(turn, turn) * turingSpeed)
		backLeftVector += (Vector2(-turn, -turn) * turingSpeed)
		backRightVector += (Vector2(-turn, turn) * turingSpeed)
		
		frontLeftVector = frontLeftVector.reflect(Vector2.UP).rotated(PI / 2)
		frontRightVector = frontRightVector.reflect(Vector2.UP).rotated(PI / 2)
		backLeftVector = backLeftVector.reflect(Vector2.UP).rotated(PI / 2)
		backRightVector = backRightVector.reflect(Vector2.UP).rotated(PI / 2)

		frontLeftWheel.steering = frontLeftVector.angle()
		frontRightWheel.steering = frontRightVector.angle()
		backLeftWheel.steering = backLeftVector.angle()
		backRightWheel.steering = backRightVector.angle()

		frontLeftWheel.engine_force = frontLeftVector.length()
		frontRightWheel.engine_force = frontRightVector.length()
		backLeftWheel.engine_force = backLeftVector.length()
		backRightWheel.engine_force = backRightVector.length()
		
		lastFrontLeftAngle = frontLeftWheel.steering
		lastFrontRightAngle = frontRightWheel.steering
		lastBackLeftAngle = backLeftWheel.steering
		lastBackRightAngle = backRightWheel.steering

		frontLeftWheel.brake = 0
		frontRightWheel.brake = 0
		backLeftWheel.brake = 0
		backRightWheel.brake = 0

	#frontLeftWheel.steering = strafe.angle() + turn
	#frontRightWheel.steering = strafe.angle() + turn
	#backLeftWheel.steering = strafe.angle() + turn
	#backRightWheel.steering = strafe.angle() + turn
	#
	#frontLeftWheel.engine_force = strafe.length()
	#frontRightWheel.engine_force = strafe.length()
	#backLeftWheel.engine_force = strafe.length()
	#backRightWheel.engine_force = strafe.length()
