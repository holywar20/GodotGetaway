extends Control

onready var nameTextBox = $VBox/Center/Grid/NameTextBox
onready var portTextBox = $VBox/Center/Grid/PortTextBox
onready var ipTextBox = $VBox/Center/Grid/IPTextBox

func _ready():
	nameTextBox.text = Saved.saveData["PlayerName"]

func _onHostGameButtonDown():
	Network.createServer()
	createWaitingRoom()

func _onJoinGameButtonDown():
	Network.connectToServer()
	createWaitingRoom()

func _onChangeNamedTextBox( newText ):
	Saved.saveData["PlayerName"] = newText
	Saved.saveGame()

func createWaitingRoom():
	$WaitingRoom.popup_centered()

