extends Node

const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 23023
const MAX_PLAYERS = 4

var localPlayerId = 0

signal playerDisconneceted
signal serverDisconnected 

func _ready():
	get_tree().connect("network_peer_connected" , self , "_onPlayerConnected")
	get_tree().connect("network_peer_disconnected", self, "_onPlayerDisconnected" )


func _onPlayerConnected():
	pass

func _onPlayerDisconnected():
	pass

func _sendPlayerInfo(id):
	pass

func createServer():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server( DEFAULT_PORT , MAX_PLAYERS )
	get_tree().set_network_peer( peer )

	setLocalPlayerId()
	print("Server has been created")
	print("I am " + localPlayerId )

func setLocalPlayerId():
	localPlayerId = get_tree().get_network_unique_id()
