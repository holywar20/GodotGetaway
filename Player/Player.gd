extends VehicleBody


const MAX_STEER_ANGLE : float = 0.35
const STEER_SPEED = 1

const MAX_ENGINE_FORCE = 375
const MAX_BRAKE_FORCE = 10
const MAX_SPEED = 100

# current state
var steerTarget = 0.0
var steerAngle = 0.0

sync var players = {}
var playerData = {"steer" : 0 , "engine" : 0 , "brakes": 0 , "position" :null }

func _ready():
	players[name] = playerData
	players[name].position = transform

	if not isLocalPlayer():
		$Camera.queue_free()

# Network
func isLocalPlayer():
	return name == str(Network.localPlayerId)

func _updateServer( id , steer , engine, brakes ):
	if not Network.localPlayerId == 1:
		rpc_unreliable_id( 1 , "manageClients" , id, steer, engine, brakes )
	else:
		manageClients( id , steer , engine, brakes )

sync func manageClients( id , steer , engine, brakes ):
	players[id].steer = steer
	players[id].engine = engine
	players[id].brakes = brakes
	players[id].position = transform
	
	rset_unreliable("players" , players)

# Physics
func _physics_process(delta):
	if isLocalPlayer():
		drive( delta )
	if not Network.localPlayerId == 1:
		transform = players[name].position

	engine_force = players[name].engine
	steering = players[name].steer
	brake = players[name].brakes


func drive( delta : float ):
	var engineForceVal = applyThrottle()
	var steeringVal = applySteering( delta )
	var brakeVal = applyBrakes()

	_updateServer( name,  steeringVal, engineForceVal, brakeVal )


func applyBrakes():
	var brakeVal = 0
	var brakeStrength = Input.get_action_strength("Brake")

	if( brakeStrength ):
		brakeVal = brakeStrength
	

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

