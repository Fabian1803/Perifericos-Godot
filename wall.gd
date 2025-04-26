extends StaticBody2D

func _ready():
	name = "wall"  # Importante para el reconocimiento automático
	add_to_group("environment")  # Opcional para agrupar objetos

func get_description() -> String:
	return "un muro sólido"  # Descripción personalizada

# Opcional: Si quieres que el muro pueda destruirse
func destroy():
	queue_free()
