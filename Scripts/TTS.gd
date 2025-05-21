extends Node

var voz_espanol_id: String = ""
var hablando: bool = false
const VELOCIDAD_HABLAR: float = 1.5

func _ready():
	var voces = DisplayServer.tts_get_voices()
	for v in voces:
		if v.get("language", "").begins_with("es"):
			voz_espanol_id = v["id"]
			print("✅ Voz en español detectada:", voz_espanol_id)
			return
	print("❌ No se encontró una voz en español.")

func hablar(texto: String) -> void:
	DisplayServer.tts_stop()
	if texto.strip_edges() == "":
		print("⚠️ Texto vacío.")
		return

	if hablando:
		await get_tree().create_timer(0.1).timeout
		hablando = false

	if voz_espanol_id != "":
		hablando = true
		DisplayServer.tts_speak(texto, voz_espanol_id, 100, 1.0, VELOCIDAD_HABLAR)
		var duracion_estimada = texto.length() / (15.0 * VELOCIDAD_HABLAR)
		await get_tree().create_timer(duracion_estimada).timeout
		hablando = false
	else:
		print("❌ No se puede hablar: No hay voz en español disponible.")

func cancelar() -> void:
	if hablando:
		DisplayServer.tts_stop()
		hablando = false
