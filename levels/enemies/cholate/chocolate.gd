extends Area2D

@export var speed: float = 400.0
signal on_chocolate_hit_player()
var velocity: Vector2 = Vector2.ZERO
var active: bool = false
var limit_y = 0

func set_limit_y(new_limit_y: int):
	limit_y = new_limit_y

func _ready():
	scale = Vector2(0.1, 0.1)
	deactivate()
	body_entered.connect(_on_body_entered)

func start(_position: Vector2, _direction: Vector2, _limit_y: int):
	position = _position
	velocity = _direction.normalized() * speed
	limit_y = _limit_y
	active = true
	visible = true
	monitoring = true 

func deactivate():
	active = false
	visible = false
	monitoring = false
	position = Vector2(10000, 10000)

func _physics_process(delta):
	if active:
		position += velocity * delta

func _on_body_entered(body):
	if body.name == "Player": 
		on_chocolate_hit_player.emit()
		deactivate()
