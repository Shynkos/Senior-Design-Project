extends CanvasLayer


func _process(delta):
	if Input.is_action_just_pressed("Pause") and !$ControlsMenu.visible and !$VideoMenu.visible:
		visible = true


func _on_resume_button_pressed():
	visible = !visible


func _on_options_button_pressed():
	visible = !visible
	$OptionsMenu.visible = !visible


func _on_quit_button_pressed():
	get_tree().quit()


func _on_options_menu_back():
	visible = true


func _on_options_menu_controls():
	$ControlsMenu.visible = true


func _on_controls_menu_back():
	$OptionsMenu.visible = true


func _on_video_menu_back():
	$OptionsMenu.visible = true


func _on_options_menu_video():
	$VideoMenu.visible = true


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Levels/RoomOne.tscn")
