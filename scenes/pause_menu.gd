extends CanvasLayer

signal options

func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		visible = !visible

func _on_resume_button_pressed():
	visible = !visible

func _on_options_button_pressed():
	visible = !visible
	options.emit()
