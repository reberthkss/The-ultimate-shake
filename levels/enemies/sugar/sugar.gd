extends CharacterBody2D

enum State { IDLE, ATTACKING }
var current_state = State.IDLE

@export var movement_speed: float = 200.0
@export var turn_speed: float = 2.0
var sugar_enabled = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var hp = 100
var target_body: Node2D = null
signal sugar_gotch_player()
signal sugar_defeat()

func set_sugar_enabled(_sugar_enabled: bool):
	sugar_enabled = _sugar_enabled

@onready var detection_area = $DetectionArea

func _ready():
	detection_area.body_entered.connect(_on_player_detected)

func _physics_process(delta):
	if not sugar_enabled:
		hide()
		return
	match current_state:
		State.IDLE:
			velocity = Vector2.ZERO
			
		State.ATTACKING:
			if target_body != null:
				var direction_to_player = (target_body.global_position - global_position).normalized()
				
				velocity.x = lerp(velocity.x, direction_to_player.x * movement_speed, turn_speed * delta)
				velocity.y = lerp(velocity.y, direction_to_player.y * movement_speed, turn_speed * delta)
			else:
				velocity.y += gravity * delta
			
			check_sugar_collision_with_player()

	move_and_slide()

func check_sugar_collision_with_player():
	var obj_collider = get_last_slide_collision()
	
	if obj_collider == null:
		return
		
	var obj = obj_collider.get_collider()
	
	if obj.name == "Player":
		sugar_gotch_player.emit()

func _on_player_detected(body):
	if current_state == State.IDLE and body is CharacterBody2D: 
		target_body = body
		current_state = State.ATTACKING
		
		velocity.y = -200

func handle_hit_by_player():
	hp -= 10
	
	print("sugar hp => ", hp)
	if hp == 0:
		sugar_defeat.emit()
