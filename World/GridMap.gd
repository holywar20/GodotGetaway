extends GridMap

# Road Generation
const N = 1
const E = 2
const S = 4
const W = 8

const NS_GAP = 5
const EW_GAP = 10
const WALL_CUTOFF = 15

#Building generation
var validBuildingRotations = [ 0,10,16,22 ] # Valid Rotations
var basicBuldings = [16, 17] # Mesh library refrences

const SKY_SCRAPPER = 18
const SKYSCRAPER_CHANCE = 1 # Percentile chance of a skyscrapper

# Map Size, Factors
var width : int = 25
var depth : int = 25
var spacing : int = 3

var eraseFraction : float = 0.25

#child Nodes
onready var border = $Border
onready var objectSpawner : Node = $ObjectSpawner

var cellWalls = {
	Vector3(0 , 0 , -spacing) : N ,
	Vector3( spacing , 0 , 0 ): E ,
	Vector3(0 , 0 , spacing ) : S ,
	Vector3( -spacing , 0 , 0 ) : W
}

func _ready():
	clear()
	if Network.localPlayerId == 1:
		makeMap()
		rpc("sendReady")

func makeMap():
	randomize()
	makeMapBorder()
	_makeBlankMap()
	makeMaze()
	eraseWalls()

	recordTilePositions()

# Recursive backtracker algorithm.
func makeMaze():
	var unvisited = [] #list of locations we haven't visited.
	var stack = [] # Locations we might need to go back to. 

	for x in range( 0, width, spacing ):
		for z in range ( 0, depth, spacing ):
			unvisited.append( Vector3( x, 0 , z) )

	var current = Vector3( 0 , 0 , 0)
	unvisited.erase( current )

	while unvisited:
		var neighbours = checkNeighbor( current, unvisited  )
		
		if neighbours.size() > 0:
			stack.append( current )

			var next : Vector3
			next = neighbours[randi() % neighbours.size()]
			
			var direction : Vector3 = next - current

			# Current tile value for current and previous walls. Note this only permits values between 0 and 15. 16+ are building
			var currentWalls = min( get_cell_item( current.x , 0 , current.z ) , 15)  - cellWalls[direction]
			var nextWalls = min( get_cell_item( int(next.x) , 0,  int(next.z) ) , 15)- cellWalls[-direction]

			rpc("placeTile", current.x , current.z , currentWalls , 0 )
			rpc("placeTile",  next.x , next.z , nextWalls, 0 )

			_fillGaps( current , direction )

			current = next
			unvisited.erase( current )
		elif stack:
			current = stack.pop_back()

func makeMapBorder():
	border.resizeBorder( Vector2( 20, 20) , Vector2( width , depth ) )

func eraseWalls():
	var wallsToErase = width * depth * eraseFraction
	for _i in range( 1 , wallsToErase ):
		var x : int = int( rand_range( 1 , width / spacing ) ) * spacing
		var z : int = int( rand_range( 1 , depth / spacing ) ) * spacing
		
		var currCell = Vector3( x , 0 , z )
		var currCellWalls : int = get_cell_item( currCell.x, 0, currCell.z )
		currCellWalls = clamp( currCellWalls , 0 , WALL_CUTOFF )

		var nextCell : Vector3 = cellWalls.keys()[randi() % cellWalls.size()]

		# Bitwise and - checks if a wall exists between cell & the neighbor
		if currCellWalls & cellWalls[nextCell]:
			currCellWalls = currCellWalls - cellWalls[nextCell]
			rpc("placeTile", currCell.x , currCell.z , currCellWalls , 0 )

			# Note - we are inverting the key which flips the direction, which is what we want.
			var nextWalls : int = get_cell_item( currCell.x + nextCell.x , 0 , currCell.z + nextCell.z ) - cellWalls[-nextCell]
			nextWalls = clamp(nextWalls,  0 , WALL_CUTOFF )
			rpc("placeTile", currCell.x + nextCell.x , currCell.z + nextCell.z , nextWalls , 0 )

			_fillGaps( currCell, nextCell ) 

# Fill in spacing elements to ensure consistant maze.
func _fillGaps( _current : Vector3 , _direction : Vector3 ):
	var tileType
	for _i in range( 1 , spacing ):
		if _direction.x > 0:
			tileType = NS_GAP
			_current.x += 1
		elif _direction.x < 0:
			tileType = NS_GAP
			_current.x -= 1
		elif _direction.z > 0:
			tileType = EW_GAP
			_current.z += 1
		elif _direction.z < 0:
			tileType = EW_GAP
			_current.z -= 1
		
		rpc("placeTile", _current.x , _current.z , tileType , 0 )


func checkNeighbor( _cell : Vector3, _unvisited : Array ):
	var list = []

	for n in cellWalls.keys():
		if _cell+n in _unvisited:
			list.append(_cell+n)

	return list

func _makeBlankMap():
	for x in width:
		for z in depth:
			var bNumber : int = _pickBuilding()
			var rotation : int = validBuildingRotations[randi() % validBuildingRotations.size() - 1]
			rpc("placeTile", x , z , bNumber , rotation )


func _pickBuilding() -> int :
	var building : int
	if( randi() % 99 <= SKYSCRAPER_CHANCE ):
		building = SKY_SCRAPPER
	else: 
		building = basicBuldings[randi() % basicBuldings.size() - 1]
	
	return building
# Called every frame. 'delta' is the elapsed time since the previous frame.

# Utility functions 

func recordTilePositions():
	var tiles = []

	for x in range( 0 , width ):
		for z in range( 0 , depth ):
			var currCell = Vector3( x , 0 , z )
			var currTile = get_cell_item( x, 0 , z )

			if( currTile < WALL_CUTOFF ):
				tiles.append( currCell )
	
	objectSpawner.generateProps( tiles, Vector2( width, depth ) )


# Network functions
sync func placeTile( x , z , tileNum , rotation = 0):
	set_cell_item( x, 0 , z ,tileNum , rotation )

sync func sendReady():
	if( Network.localPlayerId  == 1 ):
		playerReady()
	else:
		rpc_id( 1 , "playerReady")

remote func playerReady():
	Network.readyPlayers += 1
	if ( Network.readyPlayers == Network.players.size() ):
		rpc("sendGo")

sync func sendGo():
	get_tree().call_group("GameState" , "unPause")
