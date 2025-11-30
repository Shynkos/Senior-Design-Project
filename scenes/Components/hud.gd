extends CanvasLayer

@onready var hearts = [$Health1, $Health2, $Health3, $Health4, $Health5, $Health6, $Health7]

func _ready():
	for i in range(0, PlayerGlobal.Health):
		hearts[i].visible = true
