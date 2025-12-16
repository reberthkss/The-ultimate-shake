extends Node2D

@export_category("Level configuration")
@export var platform_scene: PackedScene
@export var background: Texture2D
@export var banana_enabled: bool = true
@export var straw_berry_enabled: bool = false
@export var ice_enabled: bool = false
@export var mirtilo_enabled: bool = false
@export var chocolate_enabled: bool = false
@export var sugar_enabled: bool = false
@export_multiline var welcome_message: String = "Prepare-se!"

@onready var player = $Player
@onready var welcome_label = $CanvasLayer/WelcomeMessage

signal on_next_level()
signal on_try_again()

var screen_size: Vector2
var y_spawn_offset: float = 20.0 
var last_platform: Vector2 = Vector2(0,0)
var LIMIT_LEFT = -840
var LIMIT_RIGHT = 840
var sugar_in_player_ref = null 

func _ready():
	screen_size = get_viewport_rect().size
	player.scale = Vector2(0.2, 0.2)
	$BottomBubbles.visible = false
	$ParallaxBackground/ParallaxLayer/Sprite2D.texture = background
	welcome_label.text = welcome_message
	$Sugar.set_sugar_enabled(sugar_enabled)
	$SugarLeft.set_sugar_enabled(sugar_enabled)
	animate_welcome()

func _process(delta):
	for platform in $Platforms.get_children():
		if platform.position.y > player.position.y + (screen_size.y / 2):
			platform.queue_free()

func _on_player_request_floor(position: Vector2) -> void:
	
	if last_platform.y != 0 and  last_platform.y < position.y	:
		return
	
	var direction = 1 if randi_range(-1, 1) > 0 else -1
	var next_platform_x = last_platform.x + (150 * direction)
	var next_platform_y = last_platform.y - 100
	
	if next_platform_x < LIMIT_LEFT:
		next_platform_x += 300
		
	if next_platform_x > LIMIT_RIGHT:
		next_platform_x -= 300
		
	var spawn_position = Vector2(next_platform_x, next_platform_y)
	var new_platform = platform_scene.instantiate()
	
	var type: int = -1
	
	while type == -1:
		var floor_type = Global.get_randomized_floor_type()
		
		if floor_type == Global.FloorType.BANANA && banana_enabled:
			type = floor_type
		
		if floor_type == Global.FloorType.STRAW_BERRY && straw_berry_enabled:
			type = floor_type
			spawn_position.x += 50 * direction
			
		if floor_type == Global.FloorType.ICE && ice_enabled:
			type = floor_type
		
		if floor_type == Global.FloorType.MIRTILO && mirtilo_enabled:
			type = floor_type
			
	
	new_platform.set_type(type)
		
	new_platform.position = spawn_position
	
	$Platforms.add_child(new_platform)
	
	last_platform = spawn_position
		
	request_chocolate_enemy(spawn_position)

func _on_next_level_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		on_next_level.emit()

func _on_camera_game_over() -> void:
	$EndScreen.show_result(false)

func show_bottom_bubbles():
	$BottomBubbles.visible = true
	
func animate_welcome():
	welcome_label.visible = true
	welcome_label.modulate.a = 1.0
	
	var tween = create_tween()
	
	tween.tween_interval(2.0)
	
	tween.tween_property(welcome_label, "modulate:a", 0.0, 1.0)
	
	tween.tween_callback(welcome_label.hide)

func request_chocolate_enemy(next_platform_position):
	var viewport_rect = get_viewport_rect()
	var half_height = viewport_rect.size.y / 8
	
	var camera_center = $Camera.get_screen_center_position()
	
	var direction = 1 if next_platform_position.x < 0 else -1
	
	var spawn_x = next_platform_position.x + 150 * direction
	
	var spawn_y = camera_center.y - half_height - 100
	var final_spawn_pos = Vector2(spawn_x, spawn_y)
	
	if chocolate_enabled:
		$ChocolateParticles.spawn_chocolate(final_spawn_pos, Vector2(0, 300))

func _on_chocolate_particles_on_chocolate_hit_player() -> void:
	player.hit_by_chocolate()

func sugar_gotcha_player(sugar_ref: CharacterBody2D):
	player.sugar_gotcha()
	sugar_in_player_ref = sugar_ref
	sugar_ref.hide()
	
func sugar_defeat(sugar_ref):
	player.on_sugar_defeat()

func _on_sugar_sugar_gotch_player() -> void:
	sugar_gotcha_player($Sugar)

func _on_sugar_left_sugar_gotch_player() -> void:
	sugar_gotcha_player($SugarLeft)

func _on_player_hit_sugar() -> void:
	sugar_in_player_ref.handle_hit_by_player()

func _on_sugar_sugar_defeat() -> void:
	$SugarLeft.set_sugar_enabled(false)
	sugar_defeat($Sugar)

func _on_sugar_left_sugar_defeat() -> void:
	$Sugar.set_sugar_enabled(false)
	sugar_defeat($SugarLeft)

func _on_player_player_start_jump() -> void:
	$Walls/Floor.disabled = true
