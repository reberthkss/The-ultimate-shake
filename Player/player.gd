extends CharacterBody2D

# --- Variáveis de Movimento ---
# Velocidade de movimento para os lados
@export var speed = 400.0
# Força do pulo automático
@export var jump_velocity = -1800.0

@onready var shape_2d = $Sprite2D

var is_on_base_platform = true

signal request_floor()

# Pega o valor da gravidade das configurações do projeto
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func update_texture(sprite_2d, texture_path):
	var texture = load(texture_path)
	sprite_2d.texture = texture

func _input(event: InputEvent) -> void:
	# Para o celular, usaríamos o acelerômetro. A linha abaixo está comentada,
	# mas é como você faria. Descomente e apague a linha de cima para testar no celular.
	# var direction = Input.get_accelerometer().x * 2 # Multiplicamos por 2 para mais sensibilidade
	
	if event is InputEventKey:
		## TODO(Reberth): Fix the movement freeze
		#if not event.is_pressed() and not event.echo:
			#if event.keycode == KEY_A or event.keycode == KEY_D:
				#velocity.x = move_toward(velocity.x, 0, speed)
				#
		if event.is_pressed() and not event.echo:
			if event.keycode == KEY_W and is_on_base_platform:
				velocity.y = jump_velocity
				request_floor.emit()
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
		
	# --- 1. Adicionar Gravidade ---
	# Se o personagem não estiver no chão, aplica a gravidade.
	if not is_on_floor():
		velocity.y += gravity * delta
		if (velocity.y < 0):
			update_texture($Sprite2D, "res://Player/player_on_air_up.png")
		else:
			update_texture($Sprite2D, "res://Player/player_on_air_down.png")

	# --- 2. Pulo Automático ---
	# Se o personagem está no chão, ele pula automaticamente.
	# Esta é a mecânica principal do nosso jogo estilo Doodle Jump!
	if is_on_floor():
		velocity.y += jump_velocity
		request_floor.emit()
		

	# --- 4. Animação (Básico) ---
	# Vira o sprite para a direção que o personagem está se movendo
	if velocity.x < 0:
		$Sprite2D.flip_h = true
	elif velocity.x > 0:
		$Sprite2D.flip_h = false

	# --- 5. Mover o Personagem ---
	# A função que efetivamente move o nosso corpo e detecta colisões
	

func get_feet_position_y():
	var sprite_2d_height =  $Sprite2D.get_rect().size.y
	return $CollisionShape2D.position[1] + sprite_2d_height/2
