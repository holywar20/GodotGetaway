extends Spatial

onready var playerBase = $PlayerBase

const PLAYER_SCENE = "res://Player/Player.tscn"

func _ready():
	spawnLocalPlayer()
	rpc("spawnRemotePlayer" , Network.localPlayerId )

func spawnLocalPlayer():
	var newPlayer = preload( PLAYER_SCENE ).instance()

	newPlayer.translation = Vector3( 10 , 2, 10 )
	newPlayer.name = str( Network.localPlayerId )

	playerBase.add_child( newPlayer )

remote func spawnRemotePlayer( id ):
	var newPlayer = preload( PLAYER_SCENE ).instance()
	newPlayer.name = str( id )
	
	playerBase.add_child( newPlayer )



