extends Area2D


@export var ConnectedRoom: String

@export var PlayerPos: Vector2
@export var PlayerJumpOnEnter: bool = false





func _on_area_entered(area: Area2D) -> void:
	print("test")
	if area.get_parent().is_in_group("player"):
		print("test2")
		RoomChangeGlobal.Activate = true
		RoomChangeGlobal.PlayerPos = PlayerPos
		RoomChangeGlobal.PlayerJumpOnEnter = PlayerJumpOnEnter
		get_tree().call_deferred("change_scene_to_file", ConnectedRoom)
