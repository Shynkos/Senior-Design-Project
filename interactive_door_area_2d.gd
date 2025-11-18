extends Area2D


@export var ConnectedRoom: String

@export var PlayerPos: Vector2
@export var PlayerJumpOnEnter: bool = false


func _ready():
	add_to_group("Interactable")


func interact():
	RoomChangeGlobal.Activate = true
	RoomChangeGlobal.PlayerPos = PlayerPos
	RoomChangeGlobal.PlayerJumpOnEnter = PlayerJumpOnEnter
	get_tree().call_deferred("change_scene_to_file", ConnectedRoom)
