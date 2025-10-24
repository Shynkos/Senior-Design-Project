extends CanvasLayer

signal back


func update_labels():
	$"MoveRight".text = InputMap.action_get_events("Move right")[0].as_text()
	$"MoveLeft".text = InputMap.action_get_events("Move left")[0].as_text()
	$"Jump".text = InputMap.action_get_events("Jump")[0].as_text()


func _ready():
	update_labels()


func _process(delta):
	if Input.is_action_just_pressed("Pause") and visible:
		visible = !visible
		back.emit()
		

func rebind_action(action: String):
	while true:
		await get_tree().process_frame
		if Input.is_anything_pressed():
			for keycode in range(256):
				if Input.is_key_pressed(keycode):
					print(keycode)
					var key_event = InputEventKey.new()
					key_event.keycode = keycode
					InputMap.action_erase_event(action, InputMap.action_get_events(action)[0])
					InputMap.action_add_event(action, key_event)
					break
			break
		if Input.is_key_pressed(KEY_ESCAPE):
			break
	update_labels()


func _on_move_right_pressed():
	rebind_action("Move right")
