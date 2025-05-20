extends Control

func _on_StartButton_pressed():
	get_tree().change_scene_to_file("res://Game_Main/game_main.tscn")

func _on_PauseButton_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func _on_ExitButton_pressed():
	var confirm_dialog = ConfirmationDialog.new()
	confirm_dialog.dialog_text = "¿Estás seguro que quieres salir del juego?"
	confirm_dialog.confirmed.connect(_exit_game)
	confirm_dialog.canceled.connect(confirm_dialog.queue_free)
	add_child(confirm_dialog)
	confirm_dialog.popup_centered()

func _exit_game():
	get_tree().quit()  # Cierra la aplicación
