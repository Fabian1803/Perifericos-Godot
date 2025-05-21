extends Control

@onready var input_text = $VBoxContainer/textVoz
@onready var button = $VBoxContainer/ButtonCar

func _ready():
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	var texto = input_text.text.strip_edges()
	if texto != "":
		TTS.hablar(texto)
	else:
		TTS.hablar("No hay texto para leer.")
