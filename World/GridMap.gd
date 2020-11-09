extends GridMap

const N = 1
const E = 2
const S = 4
const W = 8

var width = 20
var depth = 20
var spacing = 1

var cellWalls = {
	Vector3(0,0, -spacing) : N ,
	Vector3() 
}

func _ready():
	clear()
	randomize()

	makeMap()

func makeMap()

func checkNeighbor( cell , unvisited ):
	pass

func makeBlankMap():
	for x in width:
		for z in depth:
			var cell = randi() % 15
			set_cell_item(x , 0 , z , 15 )

# Called every frame. 'delta' is the elapsed time since the previous frame.
