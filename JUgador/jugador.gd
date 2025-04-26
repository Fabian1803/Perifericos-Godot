extends CharacterBody2D

# Configuración de movimiento
@export var move_speed: float = 200.0
@export var acceleration: float = 8.0
@export var friction: float = 0.2

# Configuración de voz
@export var voice_speed: int = 0  # Rango -10 a 10

# Configuración de detección
@export var detection_distance := 200.0

# Descripciones de objetos
var environment_descriptions = {
	"door": "una puerta",
	"wall": "un muro",
	"chest": "un cofre",
	"key": "una llave"
}

func _ready():
	setup_raycasts()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	handle_movement(delta)
	move_and_slide()

func handle_movement(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	
	if input_dir != Vector2.ZERO:
		# Actualizar velocidad y rotación
		velocity = velocity.lerp(input_dir * move_speed, acceleration * delta)
		rotation = input_dir.angle()  # Rotar hacia la dirección de movimiento
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)

func setup_raycasts():
	# Direcciones relativas al jugador (Front = adelante = derecha local)
	var directions = {
		"Front": Vector2.RIGHT,
		"Left": Vector2.UP,
		"Right": Vector2.DOWN,
		"Back": Vector2.LEFT
	}
	
	for dir in directions:
		if $Area2D.has_node(dir):
			var ray = $Area2D.get_node(dir) as RayCast2D
			ray.target_position = directions[dir] * detection_distance
			ray.enabled = true

func get_environment_description() -> String:
	var directions = {
		"Front": $Area2D/Front,
		"Left": $Area2D/Left,
		"Right": $Area2D/Right,
		"Back": $Area2D/Back
	}
	
	var descriptions := []
	var objects_detected = false
	
	for dir in directions:
		var obj = detect_object(directions[dir])
		if obj != "nada":
			descriptions.append(format_direction(dir, obj))
			objects_detected = true
	
	return "En tu entorno: " + ". ".join(descriptions) if objects_detected else "A tu alrededor hay nada"

func detect_object(ray: RayCast2D) -> String:
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider.has_method("get_description"):
			return collider.get_description()
		elif collider.name in environment_descriptions:
			return environment_descriptions[collider.name]
	return "nada"

func format_direction(dir: String, obj: String) -> String:
	var translations = {
		"Front": "Al frente hay {0}",
		"Left": "a la izquierda hay {0}",
		"Right": "a la derecha hay {0}",
		"Back": "detrás hay {0}"
	}
	return translations[dir].format([obj])

func speak(text: String):
	var sanitized_text = text.replace("\"", "\\\"")
	if OS.get_name() == "Windows":
		OS.execute("powershell", [
			"-Command", 
			"Add-Type -AssemblyName System.Speech; $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer; $speak.Rate = {0}; $speak.Speak('{1}');".format([voice_speed, sanitized_text])
		], [], false)
	else:
		OS.execute("espeak-ng", ["-v", "es", "-s", str(voice_speed * 20 + 100), sanitized_text], [], false)

func _input(event: InputEvent):
	if Input.is_action_just_pressed("interact"):
		var description = get_environment_description()
		speak(description)
