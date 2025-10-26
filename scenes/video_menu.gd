extends CanvasLayer

signal back


func _process(delta):
	if Input.is_action_just_pressed("Pause") and visible:
		visible = !visible
		back.emit()


func _on_fullscreen_toggle_toggled(toggled_on: bool):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_v_sync_toggle_toggled(toggled_on: bool):
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
