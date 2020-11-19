extends Spatial

onready var playerBase = $PlayerBase

const PLAYER_SCENE = "res://Player/Player.tscn"

func _enter_tree():
	get_tree().paused = true;

func _ready():
	pass
	

func spawnLocalPlayer():
	var newPlayer = preload( PLAYER_SCENE ).instance()

	newPlayer.translation = Vector3( 14 , 2, 14 )
	newPlayer.name = str( Network.localPlayerId )

	playerBase.add_child( newPlayer )

func unPause():
	get_tree().paused = false;
	
	spawnLocalPlayer()
	rpc("spawnRemotePlayer" , Network.localPlayerId )

remote func spawnRemotePlayer( id ):
	var newPlayer = preload( PLAYER_SCENE ).instance()
	newPlayer.name = str( id )
	newPlayer.translation = Vector3( 14 , 2, 14 )

	playerBase.add_child( newPlayer )



