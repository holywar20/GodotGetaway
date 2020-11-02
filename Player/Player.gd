extends VehicleBody

const MAX_STEER_ANGLE = 0.35
const STEER_SPEED = 1

const MAX_ENGINE_FORCE = 175
const MAX_BRAKE_FORCE = 10
const MAX_SPEED = 100

# current state
var steerTarget = 0.0
var steerAngle = 0.0

func _ready():
	pass

func _physics_process(delta):
	drive( delta )

func drive( delta ):
	steering = applySteering( delta )
	engine_force = applyThrottle()
	brake = applyBrakes()

func applyBrakes():
	var brakeVal = 0
	var brakeStrength = Input.get_action_strength("Brake")

	if( brakeStrength ):
		brakeVal = brakeStrength
	
	print( brakeVal )

	return brakeVal * MAX_BRAKE_FORCE


func applyThrottle():
	var throttleVal = 0
	var forward = Input.get_action_strength("Forward")
	var back = Input.get_action_strength("Back")

	if linear_velocity.length() < MAX_SPEED:
		if back:
			throttleVal = -back
		if forward:
			throttleVal = forward

	return throttleVal * MAX_ENGINE_FORCE

func applySteering( delta ):
	var steerVal = 0.0
	var left = Input.get_action_strength("SteerLeft")
	var right = Input.get_action_strength("SteerRight")

	if( left ):
		steerVal = left
	elif( right ):
		steerVal = -right

	steerAngle = steerVal * MAX_STEER_ANGLE

	if( steerTarget < steerAngle ):
		steerAngle -= STEER_SPEED * delta
	elif ( steerTarget > steerAngle ):
		steerAngle += STEER_SPEED * delta

	return steerAngle

