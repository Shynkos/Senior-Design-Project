extends CanvasLayer

signal options

func _process(delta):
	pass

func _on_resume_button_pressed():
	visible = !visible

func _on_options_button_pressed():
	visible = !visible
	options.emit()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
