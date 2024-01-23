extends Node
class_name Utils

# Get the closest angle between the given angles
static func closest_angle(a: float, b: float) -> float:
	# get direction
	var dir: float = float((int(b) % 360) - (int(a) % 360))
	#var dir = (b % 360.0) - (a % 360.0)
	
	# convert from -360 to 360 to -180 to 180
	if abs(dir) > 180:
		dir = -(sign(dir) * 360) + dir
	
	return dir

static func deadzone(value: float, deadzone: float) -> float:
	if abs(value) < deadzone:
		return 0
	else:
		return value
