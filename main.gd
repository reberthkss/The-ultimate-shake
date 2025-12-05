extends Node2D

@export var platform_scene: PackedScene

@onready var player = $Player

var screen_size: Vector2
var last_platform_y: float = 0.0 
var y_spawn_offset: float = 20.0 
var last_platform: Vector2 = Vector2(0,0)

func _ready():
	screen_size = get_viewport_rect().size
	player.scale = Vector2(0.3, 0.3)
	last_platform_y = player.position.y

func _process(delta):
		
	for platform in $Platforms.get_children():
		if platform.position.y > player.position.y + (screen_size.y / 2):
			platform.queue_free()

func _on_player_request_floor() -> void:
	var direction = 1 if randi_range(-1, 1) > 0 else -1
	var next_platform_x = last_platform.x + 500 * direction
	var next_platform_y = last_platform.y - 500
	
	var spawn_position = Vector2(next_platform_x, next_platform_y)
	var new_platform = platform_scene.instantiate()
	
	new_platform.scale = Vector2(0.5, 0.5)

	new_platform.position = spawn_position
	
	$Platforms.add_child(new_platform)
	
	last_platform = spawn_position
