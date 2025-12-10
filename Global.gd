extends Node

enum FloorType {
	BANANA,
	STRAW_BERRY,
	ICE,
	ICE_BREAK,
	MIRTILO
}

const AVAILABLE_FLOOR_TYPE_LIST := [
	FloorType.BANANA,
	FloorType.STRAW_BERRY,
	FloorType.ICE,
	FloorType.ICE_BREAK,
	FloorType.MIRTILO
]

func get_randomized_floor_type() -> FloorType:
	var random_index = randi_range(0, AVAILABLE_FLOOR_TYPE_LIST.size() - 1)
	
	var chosen_floor_type: FloorType = AVAILABLE_FLOOR_TYPE_LIST[random_index]
	
	return chosen_floor_type
	
