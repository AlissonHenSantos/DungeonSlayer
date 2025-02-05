extends Control

@onready var contador_de_moedas = $Container/PontosContainer/ContadorDePontos as Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contador_de_moedas.text = str(Global.score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	contador_de_moedas.text = str(Global.score)
