extends Spatial

onready var walls = {
	"north" : $NorthWall, "south" :$SouthWall , "east" : $EastWall , "west" : $WestWall
}

func _ready():
	pass

func resizeBorder( tileSize : Vector2 , tileGrid : Vector2 ):
	rpc("makeBorder" , tileSize , tileGrid )

sync func makeBorder( tileSize: Vector2, tileGrid: Vector2 ):
	var northSouthSize = tileSize.x * tileGrid.x
	var eastWestSize = tileSize.y * tileSize.y

	walls.north.translation = Vector3( northSouthSize / 2 , walls.north.height / 2 , - 1 )
	walls.north.width = northSouthSize + 2
	
	walls.south.translation = Vector3( northSouthSize / 2 , walls.south.height / 2 , northSouthSize + 1)
	walls.south.width = northSouthSize + 2
	
	walls.east.translation = Vector3( -1 , walls.east.height/2 , eastWestSize / 2)
	walls.east.width = eastWestSize + 2
	
	walls.west.translation = Vector3( eastWestSize + 1, walls.west.height / 2 ,  northSouthSize / 2 )
	walls.west.width = eastWestSize + 2
	
	for x in walls:
		walls[x].use_collision = true





