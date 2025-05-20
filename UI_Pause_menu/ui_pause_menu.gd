extends Control
var crosshair: Control
var is_paused = false

func _ready():
	hide()  ## El menú empieza oculto

func _process(_delta):  ## verificacion de ESC en cada frame
	if Input.is_action_just_pressed("btn_pausa"):
		toggle_pause()

func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused  ## Pausa o reanuda el juego
	visible = is_paused  ## Muestra u oculta el menú de pausa
	## Manejo del cursor y el crosshair
	if is_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  
		if crosshair:
			crosshair.hide()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  
		if crosshair:
			crosshair.show()

func _on_ResumeButton_pressed():
	toggle_pause()

func _on_ExitButton_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI_Menu/ui_menu.tscn")
