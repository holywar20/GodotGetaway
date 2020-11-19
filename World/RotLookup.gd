extends Node

func lookup( tile : int ) -> Array:
	var rotations = []

	match tile:
		1, 3 , 5 ,7 ,9 , 11, 13:
			rotations.append( 90 )

	match tile:
		2, 3 , 6 , 7, 10, 11, 14:
			rotations.append( 180 )
		
	match tile:
		4 , 5, 6, 7 , 12, 13, 14:
			rotations.append( 270 )

	match tile:
		8, 9 , 19, 11, 12, 13, 14:
			rotations.append( 0 )

	return rotations

