extends Node2D

@export var chocolate_scene: PackedScene
@export var pool_size: int = 100

signal on_chocolate_hit_player()

var chocolate_pool: Array[Area2D] = []

func _ready():
	for i in range(pool_size):
		var chocolate = chocolate_scene.instantiate()
		chocolate.on_chocolate_hit_player.connect(_on_chocolate_hit_player)
		add_child(chocolate)
		chocolate_pool.append(chocolate)

func spawn_chocolate(start_pos: Vector2, direction: Vector2):
	var screen_height = get_viewport_rect().size.y
	var limit_y = start_pos.y + screen_height
	for chocolate in chocolate_pool:
		if not chocolate.active:
			chocolate.start(start_pos, direction, limit_y)
			return
			
	# Optional: If all bullets are busy, you could force reuse the oldest one
	# or instantiate a new temporary one (dynamic expansion).
	print("Pool empty! Increase pool_size.")

func _on_chocolate_hit_player():
	on_chocolate_hit_player.emit()
