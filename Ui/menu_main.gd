extends Control

@onready var buttons = [
	$VBoxContainer/ButtonIniciar,
	$VBoxContainer/ButtonConfig,
	$VBoxContainer/ButtonSalida
]

var current_index := 0
var voice_speed := 1
var voice_process_id := -1
var voice_timer := Timer.new()

func _ready():
	add_child(voice_timer)
	voice_timer.timeout.connect(_delayed_announce)
	voice_timer.one_shot = true
	
	buttons[current_index].grab_focus()
	_delayed_announce()
	
	for i in range(buttons.size()):
		var button = buttons[i]
		button.connect("pressed", Callable(self, "_on_button_pressed"))
		button.connect("focus_entered", Callable(self, "_on_button_focus_changed"))


func _input(event):
	if event.is_action_pressed("num1"):
		_change_focus(0)
	elif event.is_action_pressed("num2"):
		_change_focus(1)
	elif event.is_action_pressed("num3"):
		_change_focus(2)
	elif event.is_action_pressed("ui_select"):
		_delayed_announce()
	elif event.is_action_pressed("ui_accept"):
		buttons[current_index].emit_signal("pressed")

func _change_focus(new_index: int):
	if new_index != current_index:
		current_index = new_index
		buttons[current_index].grab_focus()
		_stop_voice()
		voice_timer.start(0.05)

func _on_button_focus_changed():
	for i in range(buttons.size()):
		if buttons[i].has_focus():
			current_index = i
			_stop_voice()
			voice_timer.start(0.05)
			break

func _on_button_pressed():
	_stop_voice()
	match current_index:
		0: get_tree().change_scene_to_file("res://main.tscn")
		1: get_tree().change_scene_to_file("res://Ui/Piso1.tscn")
		2: get_tree().quit()

func _delayed_announce():
	_stop_voice()
	var text = ["Iniciar", "Configuración", "Salida"][current_index]
	_speak(text)

func _stop_voice():
	if voice_process_id != -1:
		OS.kill(voice_process_id)
		voice_process_id = -1

func _speak(text: String):
	var sanitized_text = text.replace("\"", "\\\"")
	var final_speed = voice_speed * 25 + 100
	
	if OS.has_feature("windows"):
		voice_process_id = OS.execute("powershell", [
			"-Command", 
			"Add-Type -AssemblyName System.Speech; $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer; $speak.Rate = {0}; $speak.Speak('{1}');".format([voice_speed * 2, sanitized_text])
		], [], false)
	else:
		voice_process_id = OS.execute("espeak-ng", [
			"-v", "es", 
			"-s", str(final_speed),
			"-p", "50",
			sanitized_text
		], [], false)
