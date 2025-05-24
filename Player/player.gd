extends CharacterBody3D

## Variables
var velocidad:int = 200 ## velocidad de movimiento
var direccion:Vector3 ## dirección de movimiento
var sensibilidad:float = 0.001 ## sensibilidad de la cámara
var gravedad: float = 9.8 ## fuerza de gravedad
var fuerza_salto: float = 5.0 ## fuerza del salto
var en_suelo: bool = false ## indica si está en el suelo

@onready var camara:Camera3D = $Camera3D
@onready var raycast: RayCast3D = $Camera3D/RayCast3D


## Funciones
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Capturar ratón al inicio

func _physics_process(delta):
	aplicar_gravedad(delta)
	caminar(delta)
	saltar()
	move_and_slide()
	en_suelo = is_on_floor()

func _input(event):
	if event is InputEventMouseMotion:
		mover_camara(event)
	elif event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			toggle_raton()
		elif Input.is_action_just_pressed("btn_ver"):
			detectar_objeto()

func aplicar_gravedad(delta):
	if not en_suelo:
		velocity.y -= gravedad * delta

func caminar(delta):
	direccion = transform.basis * Vector3(
		Input.get_axis("btn_izquierda", "btn_derecha"), 
		0, 
		Input.get_axis("btn_adelante", "btn_atras")
	).normalized()
	velocity.x = direccion.x * velocidad * delta
	velocity.z = direccion.z * velocidad * delta

func saltar():
	if Input.is_action_just_pressed("btn_salto") and en_suelo:
		velocity.y = fuerza_salto

func mover_camara(event):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * sensibilidad)
		camara.rotate_x(-event.relative.y * sensibilidad)
		camara.rotation.x = clamp(camara.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func toggle_raton():
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	

func detectar_objeto():
	var espacio = get_world_3d().direct_space_state
	
	var desde = camara.global_transform.origin
	var hacia = desde + camara.global_transform.basis.z * -10  # 10 metros adelante
	var parametros = PhysicsRayQueryParameters3D.new()
	parametros.from = desde
	parametros.to = hacia
	var resultado = espacio.intersect_ray(parametros) ## Realizar la consulta raycast
	if resultado:
		var objeto = resultado.collider
		if objeto.has_meta("descripcion"):
			TTS.hablar(objeto.get_meta("descripcion"))
			print(objeto.get_meta("descripcion"))
		else:
			print("Objeto sin descripción")
	else:
		print("No estás mirando ningún objeto")
