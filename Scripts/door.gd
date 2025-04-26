# door.gd
extends StaticBody2D

var locked := true

func get_description() -> String:
	return "una puerta cerrada" if locked else "una puerta abierta"

func unlock():
	locked = false
	queue_free()  # Elimina la puerta del mundo
