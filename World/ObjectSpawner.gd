extends Node

const SPAWN_PARKED_CARS = 100
const SPAWN_BILLBOARDS = 75
const SPAWN_TRAFFIC_CONES = 40


const SPAWN_TRAFFIC_CONE_RAISE = .75
const SPAWN_CAR_RAISE = .75

# Props we are using 
var propsCar = preload("res://Props/ParkedCars.tscn")
var propsBillboard = preload("res://Props/Billboards/Billboard.tscn")
var propsCones = preload("res://Props/Cones/TrafficCones.tscn")

var mapTiles : Array = []
var mapSize : Vector2 = Vector2( 0 , 0 )

onready var parent = get_node("..")
onready var rotations = $RotLookup

func generateProps( _tiles : Array , _size : Vector2 ) -> void:
	mapTiles = _tiles
	mapSize = _size
	print("Spawning Objects ... ")
	
	_placeCars()
	#_placeBillboards()
	#_placeTrafficCones()

func randTiles( _tileCount : int ) -> Array:
	var tileList = mapTiles
	var selectedTiles = []

	tileList.shuffle()
	for _i in range( _tileCount ):
		var tile = tileList[_i]
		selectedTiles.append( tile )

	return selectedTiles

func _placeTrafficCones() -> void:
	var cellList = randTiles( SPAWN_BILLBOARDS )

	for _i in range( 0 , SPAWN_BILLBOARDS ):
		var cell : Vector3 = cellList.pop_front()
		var tile : int = parent.get_cell_item( cell.x , 0 , cell.z )
		var allowedRotations : Array = rotations.lookup( tile )

		if allowedRotations.size() == 0:
			continue
		else:
			var rotation = allowedRotations[randi() % allowedRotations.size()]

			rpc("spawnTrafficCones", cell, rotation )

sync func spawnTrafficCones( _cell, _rotation ) -> void:
	var cones : Spatial = propsCones.instance()
	cones.translation = Vector3( ( _cell.x * 20 ) + 10 , _cell.y , ( _cell.z * 20 ) + 10 )
	cones.rotation_degrees = Vector3( 0 , _rotation , 0 )
	add_child( cones, true )

func _placeBillboards() -> void:
	var cellList = randTiles( SPAWN_BILLBOARDS )

	for _i in range( 0 , SPAWN_BILLBOARDS ):
		var cell : Vector3 = cellList.pop_front()
		var tile : int = parent.get_cell_item( cell.x , 0 , cell.z )
		var allowedRotations : Array = rotations.lookup( tile )

		if allowedRotations.size() == 0:
			continue
		else:
			var rotation = allowedRotations[randi() % allowedRotations.size()]
			cell.y = cell.y + SPAWN_TRAFFIC_CONE_RAISE

			rpc("spawnTrafficCones", cell, rotation )

sync func spawnBillboards( _cell, _rotation ) -> void:
	var billBoard : Spatial = propsBillboard.instance()
	billBoard.translation = Vector3( ( _cell.x * 20 ) + 10 , _cell.y , ( _cell.z * 20 ) + 10 )
	billBoard.rotation_degrees = Vector3( 0 , _rotation , 0 )
	add_child( billBoard, true )

func _placeCars() -> void:
	var cellList = randTiles( SPAWN_PARKED_CARS )

	for _i in range( 0 , SPAWN_PARKED_CARS ):
		var cell : Vector3 = cellList.pop_front()
		var tile : int = parent.get_cell_item( cell.x , 0 , cell.z )
		var allowedRotations : Array = rotations.lookup( tile )

		if allowedRotations.size() == 0:
			continue
		else:
			var rotation = allowedRotations[randi() % allowedRotations.size()]
			cell.y = cell.y + SPAWN_CAR_RAISE

			rpc("spawnCars", cell, rotation )

sync func spawnCars( _cell , _rotation ) -> void:
	var car = propsCar.instance()
	car.translation = Vector3( ( _cell.x * 20 ) + 10 , _cell.y , ( _cell.z * 20 ) + 10 )
	car.rotation_degrees = Vector3( 0 , _rotation , 0 )
	add_child( car, true )

