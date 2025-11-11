extends CanvasLayer


signal options
signal pause


func _on_resume_button_pressed():
	visible = !visible
	pause.emit()


func _on_options_button_pressed():
	visible = !visible
	options.emit()


func _on_quit_button_pressed():
	pause.emit()
	get_tree().change_scene_to_file("res://scenes/Components/start_menu.tscn")
