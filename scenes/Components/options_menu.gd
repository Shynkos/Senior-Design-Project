extends CanvasLayer


signal back
signal controls
signal video
signal pause


func _process(_delta):
	if Input.is_action_just_pressed("Pause") and visible == true:
		visible = !visible
		pause.emit()


func _on_back_button_pressed():
	visible = !visible
	back.emit()


func _on_control_settings_button_pressed() -> void:
	visible = !visible
	controls.emit()


func _on_video_settings_button_pressed() -> void:
	visible = !visible
	video.emit()
