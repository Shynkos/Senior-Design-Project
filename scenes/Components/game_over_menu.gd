extends CanvasLayer


signal respawn


func _on_respawn_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Levels/RoomTut.tscn")
	respawn.emit()
	

func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Components/start_menu.tscn")
