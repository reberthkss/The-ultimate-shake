extends CharacterBody2D

var type = Global.FloorType.BANANA
var gravity = 0
var speed = 25

func get_type():
	return type
	
func set_type(new_type: Global.FloorType):
	type = new_type

func set_gravity(new_gravity: int):
	gravity = new_gravity

func _ready() -> void:
	var texture: Texture2D
	var new_scale = Vector2(0.1, 0.1)
	var new_velocity = Vector2(0, 0)
	
	match type:
		Global.FloorType.BANANA:
			texture = load("res://floor/floor_banana.png")
		Global.FloorType.STRAW_BERRY:
			texture = load("res://floor/floor_strawberry.png")
			new_velocity.x = speed
		Global.FloorType.ICE:
			texture = load("res://floor/floor_ice.png")
		Global.FloorType.ICE_BREAK:
			texture = load("res://floor/floor_ice_break.png")
		Global.FloorType.MIRTILO:
			texture = load("res://floor/floor_mirtilo.png")
			var circle_shape: CircleShape2D = CircleShape2D.new()
			circle_shape.radius = 400
			$CollisionShape2D.shape = circle_shape
	
	$FloorSprite.texture = texture
	scale = new_scale
	velocity = new_velocity
	
func has_collided() -> bool:
	return get_slide_collision_count() > 0
	
func is_collided_with_player() -> bool:
	var colidedFloor = get_last_slide_collision()
	var obj = colidedFloor.get_collider()
	return obj != null && obj.name == "Player"

func _physics_process(delta: float) -> void:		
	gravity = 0
	velocity.y = 0
	match type:
		Global.FloorType.BANANA:
			pass
		Global.FloorType.STRAW_BERRY:
			if has_collided() and not is_collided_with_player():
				velocity.x *= -1
			move_and_slide()
			pass	
		Global.FloorType.ICE:
			if has_collided() and is_collided_with_player():
				$FloorSprite.texture = load("res://floor/floor_ice_break.png")
				type = Global.FloorType.ICE_BREAK
			move_and_slide()

		Global.FloorType.ICE_BREAK:
			pass
		Global.FloorType.MIRTILO:
			$FloorSprite.rotation_degrees += 2

func emit_sound():
	$pop.play()
