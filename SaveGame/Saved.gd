extends Node

var saveData = {}
# %APPDATA%/Name
const SAVEGAME = "user://Savegame.json"

func _ready():
	saveData = getData()

func getData():
	var file = File.new()

	if not file.file_exists( SAVEGAME ):
		saveData = {
			"PlayerName" : "unnamed"
			}
		saveGame()

	file.open( SAVEGAME , File.READ )

	var content = file.get_as_text()
	var data = parse_json( content )
	saveData = data

	file.close()

	return saveData

func saveGame():
	var saveGame = File.new()
	saveGame.open( SAVEGAME , File.WRITE )
	saveGame.store_line( to_json( saveData ) )

	saveGame.close()
