extends CanvasLayer

signal back

func _process(delta):
	if Input.is_action_just_pressed("Pause") and visible == true:
		visible = !visible


func _on_back_button_pressed():
	visible = !visible
	back.emit()
