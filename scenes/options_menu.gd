extends CanvasLayer

func _process(delta):
	if Input.is_action_just_pressed("Pause") and visible == true:
		visible = !visible
