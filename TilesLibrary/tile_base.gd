extends StaticBody3D

@export var descripcion: String = "Objeto sin descripción"

func _ready():
	set_meta("descripcion", descripcion)
