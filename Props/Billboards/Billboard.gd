extends CSGBox

const BILL_BOARD_MAT_PATH = "res://Props/Billboards/Mats/"

func _ready():
	var selectedMaterialPath : String = pickRandomMaterial()
	material = load( selectedMaterialPath )


func pickRandomMaterial() -> String:
	var matList = getFiles( BILL_BOARD_MAT_PATH )
	var selectedMaterial : String = matList[randi() % matList.size()]

	return selectedMaterial

func getFiles( folder ):
	var gatheredFiles = {}
	var fileCount = 0
	var dir = Directory.new()

	dir.open( BILL_BOARD_MAT_PATH )
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			gatheredFiles[fileCount] = folder + file
			fileCount = fileCount + 1
	
	return gatheredFiles
