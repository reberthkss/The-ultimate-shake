extends CharacterBody2D

@export var speed = 200.0
@export var jump_velocity = -700.0
@onready var shape_2d = $Sprite2D

var screen_size: Vector2
var last_platform_y: float = 0.0 
var y_spawn_offset: float = 20.0 
var last_platform: Vector2 = Vector2(0,0)
var LIMIT_LEFT = -840
var LIMIT_RIGHT = 840

var is_on_base_platform = true

signal request_floor(position: Vector2)
signal hit_banana()
signal hit_strawberry()
signal hit_ice()
signal hit_ice_break()
signal hit_mirtilo()

var gravity = 500

func update_texture(sprite_2d, texture_path):
	var texture = load(texture_path)
	sprite_2d.texture = texture

func _input(event: InputEvent) -> void:
	# Para o celular, usaríamos o acelerômetro. A linha abaixo está comentada,
	# mas é como você faria. Descomente e apague a linha de cima para testar no celular.
	# var direction = Input.get_accelerometer().x * 2 # Multiplicamos por 2 para mais sensibilidade
	
	if event is InputEventKey:
		
		if event.is_pressed() and not event.echo:
			if event.keycode == KEY_W and is_on_base_platform:
				velocity.y = jump_velocity
				request_floor.emit(position)
				is_on_base_platform = false
				
			if is_on_base_platform:
				return
				
			if event.keycode == KEY_A:
				velocity.x = -1 * speed
				
			if event.keycode == KEY_D:
				velocity.x = 1 * speed
				
func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide()
	
	if is_on_floor() && is_on_base_platform:
		return
		
	if not is_on_floor():
		velocity.y += gravity * delta
		if (velocity.y < 0):
			update_texture($Sprite2D, "res://Player/player_on_air_up.png")
		else:
			update_texture($Sprite2D, "res://Player/player_on_air_down.png")

	if is_on_floor():
		var new_velocity = Vector2(0, jump_velocity)
		
		var colidedFloor = get_last_slide_collision()
		var obj = colidedFloor.get_collider()
		
		if obj.has_method("emit_sound"):
			obj.emit_sound()
		
		if obj.has_method("get_type"):			
			if obj.get_type() == Global.FloorType.BANANA:
				hit_banana.emit()
			
			if obj.get_type() == Global.FloorType.STRAW_BERRY:
				hit_strawberry.emit()
				
			if obj.get_type() == Global.FloorType.ICE:
				new_velocity.x += 100
				new_velocity.y = jump_velocity/1.2
				hit_ice.emit()
			
			if obj.get_type() == Global.FloorType.MIRTILO:
				new_velocity.x += 100
				hit_mirtilo.emit()
			
			if obj.get_type() == Global.FloorType.ICE_BREAK:
				# Careful: obj is null after free
				obj.free()
				hit_ice_break.emit()
			
		velocity += new_velocity
		request_floor.emit(position)

	if velocity.x < 0:
		$Sprite2D.flip_h = true
	elif velocity.x > 0:
		$Sprite2D.flip_h = false

func get_feet_position_y():
	var sprite_2d_height =  $Sprite2D.get_rect().size.y
	return $CollisionShape2D.position[1] + sprite_2d_height/2
