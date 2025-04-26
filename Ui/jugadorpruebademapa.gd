extends CharacterBody2D

# Configuración de movimiento
@export var speed : float = 300.0
@export var acceleration : float = 15.0
@export var friction : float = 10.0

# Referencia a la cámara (asegúrate de que tu escena tiene una Camera2D como hijo)
@onready var camera : Camera2D = $Camera2D

func _ready():
	# Configura la cámara para que siga al personaje
	camera.make_current()
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 6.0

func _physics_process(delta):
	# Obtener input del jugador
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Aplicar movimiento
	if input_direction != Vector2.ZERO:
		velocity = velocity.move_toward(input_direction * speed, acceleration)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction)
	
	# Mover el personaje
	move_and_slide()
	
	# Ajustar zoom de la cámara (opcional)
	_handle_camera_zoom()

func _handle_camera_zoom():
	# Opcional: Permitir zoom con rueda del mouse
	if Input.is_action_just_released("zoom_in"):
		camera.zoom *= 0.9
	elif Input.is_action_just_released("zoom_out"):
		camera.zoom *= 1.1
	# Limitar zoom
	camera.zoom = camera.zoom.clamp(Vector2(0.5, 0.5), Vector2(2.0, 2.0))
