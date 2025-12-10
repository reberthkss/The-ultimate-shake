extends Camera2D

@export var player_node: Node2D

signal game_over()

func _process(delta: float) -> void:
	if player_node:
		if player_node.global_position.y < global_position.y:
			global_position.y = player_node.global_position.y
		
		global_position.x = player_node.global_position.x
	
	check_gameover()

func check_gameover():
	var screen_height = get_viewport_rect().size.y
	var player_global_position = player_node.global_position.y
	var camera_global_position = global_position.y
	var screen_offset = (screen_height/4) * 1.1
	
	if  player_global_position > global_position.y + screen_offset:
		game_over.emit()
	
