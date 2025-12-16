extends CharacterBody2D

@export var speed = 200.0
@export var jump_velocity = -600.0

@onready var anim_sprite = $sprite
@onready var shape_2d = $CollisionShape2D

enum PlayerState {
	IDLE,
	NORMAL,
	WITH_SUGAR,
	HITTING_SUGAR
}

# --- Variáveis de Jogo ---
var screen_size: Vector2
var last_platform_y: float = 0.0 
var y_spawn_offset: float = 20.0 
var last_platform: Vector2 = Vector2(0,0)
var LIMIT_LEFT = -840
var LIMIT_RIGHT = 840

var is_on_base_platform = true
var was_damaged_by_chocolate = false
var gravity = 980
var accelerometer_sensitivity = 10.0
var previous_x_direction = 1
var state = PlayerState.IDLE

# --- Sinais ---
signal request_floor(position: Vector2)
signal hit_banana()
signal hit_strawberry()
signal hit_ice()
signal hit_ice_break()
signal hit_mirtilo()
signal hit_sugar()
signal player_start_jump()

var sugar_defeat = false

func get_state():
	# Gambiarra para forcar a mudanca do state na animacao
	if sugar_defeat:
		set_state(PlayerState.NORMAL)
		return PlayerState.NORMAL
	return state

func set_state(_state: PlayerState):
	state = _state
func _ready():
	anim_sprite.animation_finished.connect(_on_animation_finished)
	anim_sprite.play("idle")
	
	if OS.get_name() in ["Android", "iOS"]:
		speed = 200

func _physics_process(delta):
	var applied_gravity = gravity
	
	if was_damaged_by_chocolate:
		applied_gravity *= 3
	
	velocity.y += applied_gravity * delta

	handle_horizontal_movement(delta)
	
	move_and_slide()
	
	handle_sprite_flip()
	
	if is_on_floor():
		handle_floor_collision()

func handle_sprite_flip():
	if velocity.x < 0:
		anim_sprite.flip_h = true
	elif velocity.x > 0:
		anim_sprite.flip_h = false

func handle_floor_collision():
	if is_on_base_platform:
		return
		
	var new_velocity = Vector2(0, jump_velocity)
	var colidedFloor = get_last_slide_collision()
	
	if colidedFloor:
		var obj = colidedFloor.get_collider()
		
		if is_instance_valid(obj):
			if obj.has_method("emit_sound"):
				obj.emit_sound()
			
			if obj.has_method("get_type"):			
				if obj.get_type() == Global.FloorType.BANANA:
					hit_banana.emit()
				elif obj.get_type() == Global.FloorType.STRAW_BERRY:
					hit_strawberry.emit()
				elif obj.get_type() == Global.FloorType.ICE:
					new_velocity.x += 100
					new_velocity.y = jump_velocity/1.2
					hit_ice.emit()
				elif obj.get_type() == Global.FloorType.MIRTILO:
					new_velocity.x += 100
					hit_mirtilo.emit()
				elif obj.get_type() == Global.FloorType.ICE_BREAK:
					obj.free()
					hit_ice_break.emit()
			
	
	# Debuff in 200 player jump
	if get_state() == PlayerState.WITH_SUGAR:
		new_velocity.y += 225
	velocity += new_velocity
	was_damaged_by_chocolate = false
	request_floor.emit(position)

func handle_horizontal_movement(delta: float):
	if is_on_base_platform:
		return
	
	if OS.get_name() not in ["Android", "iOS"]:
		return

	var accel_raw = Input.get_accelerometer().x
	
	var input_direction = accel_raw * accelerometer_sensitivity
	
	var direction = 1
		
	if input_direction < 0:
		direction = -1
		
	if previous_x_direction == direction:
		return
	
	previous_x_direction = direction
	velocity.x = speed * direction
			
func _input(event: InputEvent) -> void:
	# var direction = Input.get_accelerometer().x * 2 
	
	if event is InputEventKey:
		if event.is_pressed() and not event.echo:
			if event.keycode == KEY_W and is_on_base_platform:
				velocity.y = jump_velocity
				request_floor.emit(position)
				set_state(PlayerState.NORMAL)
				is_on_base_platform = false
				player_start_jump.emit()
			
			if is_on_base_platform:
				return
			
			if event.keycode == KEY_A:
				velocity.x = -1 * speed
			if event.keycode == KEY_D:
				velocity.x = 1 * speed
			
			# todo: when testing on device:
			#if OS.get_name() in ["Android", "iOS"]:
				#Input.vibrate_handheld(80)
			if event.keycode == KEY_F and get_state() == PlayerState.WITH_SUGAR:
				anim_sprite.play("hit")
				hit_sugar.emit()
	
	if event is InputEventScreenTouch and event.pressed:
		if is_on_base_platform:
			velocity.y = jump_velocity
			request_floor.emit(position)
			set_state(PlayerState.NORMAL)
			is_on_base_platform = false
			player_start_jump.emit()

		
		if get_state() == PlayerState.WITH_SUGAR:
			anim_sprite.play("hit")
			hit_sugar.emit()
			# Vibração
			if OS.get_name() in ["Android", "iOS"]:
				Input.vibrate_handheld(80)
				
func _on_animation_finished():
	if velocity.y > 0:
		var anim_name = "normal_down"
		if get_state() == PlayerState.WITH_SUGAR:
			anim_name = "sugar_down"
		anim_sprite.play(anim_name)
	elif velocity.y < 0:
		var anim_name = "normal_up"
		if get_state() == PlayerState.WITH_SUGAR:
			anim_name = "sugar_up"
		anim_sprite.play(anim_name)
	else:
		anim_sprite.play("idle")

func get_feet_position_y():
	var sprite_height = 0
	if anim_sprite.sprite_frames.has_animation(anim_sprite.animation):
		var texture = anim_sprite.sprite_frames.get_frame_texture(anim_sprite.animation, 0)
		sprite_height = texture.get_height()
		
	return global_position.y + (sprite_height / 2)

func hit_by_chocolate():
	if velocity.y < 0:
		velocity.y = 0 
	was_damaged_by_chocolate = true
	
func sugar_gotcha():
	set_state(PlayerState.WITH_SUGAR)

func on_sugar_defeat():
	sugar_defeat = true	
