extends Node

const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 32023
const MAX_PLAYERS = 4

const WAITING_ROOM_GROUP = "WaitingRoom"

var selectedPort : int
var selectedIp : String

var localPlayerId = 0
sync var players = {}
sync var playerData = {}
# puppet , master

signal playerDisconneceted
signal serverDisconnected 

func _ready():
	get_tree().connect("network_peer_connected" , self , "_onPlayerConnected")
	get_tree().connect("network_peer_disconnected", self, "_onPlayerDisconnected" )

func _onPlayerConnected( id ):
	if not get_tree().is_network_server():
		print( str(id) + " has connected." )


func _onPlayerDisconnected():
	pass

# Host a Server
func createServer():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server( selectedPort , MAX_PLAYERS )
	get_tree().set_network_peer( peer )

	addToPlayerList()
	
	print("Server has been created")
	print("I am " + str(localPlayerId) )


# Non Server players joining a server
func connectToServer():
	var peer = NetworkedMultiplayerENet.new()
	get_tree().connect("connected_to_server" , self, "_onConnectedToServer")
	
	peer.create_client( selectedIp , selectedPort )
	get_tree().set_network_peer( peer )

func _onConnectedToServer():
	addToPlayerList()
	rpc("_sendPlayerInfo" , localPlayerId , playerData )

# Remote key word means this is run on all peers 
remote func _sendPlayerInfo( id , data ):
	players[id] = data
	
	if( localPlayerId == 1 ):
		rset("players" , players)
		rpc("updateWaitingRoom")

func addToPlayerList():
	localPlayerId = get_tree().get_network_unique_id()
	playerData = Saved.saveData
	players[localPlayerId] = playerData

sync func updateWaitingRoom():
	get_tree().call_group( WAITING_ROOM_GROUP , "refreshPlayers" , players )
