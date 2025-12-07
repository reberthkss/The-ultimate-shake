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
	
	if player_node.global_position.y > global_position.y + (screen_height/2) * 1.1:
		game_over.emit()
	
