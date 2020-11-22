extends Node

func lookup( tile : int ) -> Array:
	var rotations = []

	# North
	match tile:
		1, 3 , 5 ,7 ,9 , 11, 13:
			rotations.append( 0 )

	# East
	match tile:
		2, 4, 6 , 7, 10, 11, 14:
			rotations.append( -90 )
	
	# South
	match tile:
		4 , 5, 6, 7 , 12, 13, 14:
			rotations.append( -180 )

	# West
	match tile:
		8, 9 , 10, 11, 12, 13, 14:
			rotations.append( -270 )

	return rotations

