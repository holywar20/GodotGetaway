extends Control

# Text boxes
onready var nameTextBox = $VBox/Center/Grid/NameTextBox
onready var portTextBox = $VBox/Center/Grid/PortTextBox
onready var ipTextBox = $VBox/Center/Grid/IPTextBox


#sub scenes
onready var waitingRoom = $WaitingRoom

func _ready():
	nameTextBox.text = Saved.saveData["PlayerName"]
	portTextBox.text = str(Network.DEFAULT_PORT)
	ipTextBox.text = str(Network.DEFAULT_IP)

func _onHostGameButtonDown():
	Network.selectedPort = int( portTextBox.text )
	Network.createServer()
	createWaitingRoom()

func _onJoinGameButtonDown():
	Network.selectedPort = int( portTextBox.text )
	Network.selectedIp = ipTextBox.text
	Network.connectToServer()
	createWaitingRoom()

func _onChangeNamedTextBox( newText ):
	Saved.saveData["PlayerName"] = newText
	Saved.saveGame()

func createWaitingRoom():
	waitingRoom.popup_centered()
	waitingRoom.refreshPlayers( Network.players )
