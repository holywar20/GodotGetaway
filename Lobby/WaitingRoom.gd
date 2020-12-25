extends Popup

onready var playerList : ItemList = $VBox/CenterContainer/ItemList

func _ready():
	playerList.clear()

func refreshPlayers( players ):
	playerList.clear()

	for id in players:
		var player = players[id]["PlayerName"]
		playerList.add_item( player , null , false )


