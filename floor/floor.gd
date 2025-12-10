extends CharacterBody2D

var type = Global.FloorType.BANANA
var gravity = 0

var platform_sound: AudioStream = null

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
	
	match type:
		Global.FloorType.BANANA:
			texture = load("res://floor/floor_banana.png")
			velocity.x = 0
			velocity.y = 0
		Global.FloorType.STRAW_BERRY:
			texture = load("res://floor/floor_strawberry.png")
			velocity.x = speed
		Global.FloorType.ICE:
			texture = load("res://floor/floor_ice.png")
		Global.FloorType.ICE_BREAK:
			texture = load("res://floor/floor_ice_break.png")
		Global.FloorType.MIRTILO:
			texture = load("res://floor/floor_mirtilo.png")
		
	$FloorSprite.texture = texture
	scale = new_scale

func _physics_process(delta: float) -> void:
	velocity.y = gravity
	move_and_slide()
	
	match type:
		Global.FloorType.BANANA:
			pass
		Global.FloorType.STRAW_BERRY:
			if get_slide_collision_count() > 0:
				var colidedFloor = get_last_slide_collision()
				var obj = colidedFloor.get_collider()
				
				if obj != null && obj.name != "Player":
					velocity.x *= -1
		Global.FloorType.ICE:
			pass
		Global.FloorType.ICE_BREAK:
			pass
		Global.FloorType.MIRTILO:
			pass

func emit_sound():
	$pop.play()
