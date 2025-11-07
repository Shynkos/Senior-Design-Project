extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D):
	print(body.name)
	if body.name == "Spike":
		print("Damage Taken")


func _on_area_entered(area: Area2D):
	print(area.name)
	if area.name == "Spike":
		print("Damage Taken")
