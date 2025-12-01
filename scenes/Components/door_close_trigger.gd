extends Area2D

@export var enabled = true
@export var door : TileMapLayer
@export var doorTileRange : Array[Vector2i] = []
@export var hitbox : CollisionShape2D
@export var camera: Camera2D
@export var room_top_left: Vector2
@export var room_bottom_right: Vector2
@export var pan_time := 1.0
@export var boss: CharacterBody2D


var doorTiles: Array[Vector2i] = []
func _ready() -> void:
	var minX = min(doorTileRange[0].x,doorTileRange[1].x)
	var minY = min(doorTileRange[0].y,doorTileRange[1].y)
	var maxX = max(doorTileRange[0].x,doorTileRange[1].x)
	var maxY = max(doorTileRange[0].y,doorTileRange[1].y)
	for x in range(minX,maxX+1):
		for y in range(minY,maxY+1):
			doorTiles.append(Vector2i(x,y))

#one time use door set
func _on_body_entered(body: Node2D) -> void:
	if enabled:
		print("test")
		for pos in doorTiles:
			door.set_cell(pos,1, Vector2i(0,1)) # 5 is tile number to replace with
		enabled = false
		door.notify_runtime_tile_data_update()
		lock_camera()

func lock_camera():
	var center := (room_top_left + room_bottom_right) * 0.5
	
	#panning
	var tween := get_tree().create_tween()
	tween.tween_property(camera, "global_position", center, pan_time)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	
	#lock cam
	tween.finished.connect(func():
		camera.limit_left = int(room_top_left.x)
		camera.limit_top = int(room_top_left.y)
		camera.limit_right = int(room_bottom_right.x)
		camera.limit_bottom = int(room_bottom_right.y)
		
		camera.position_smoothing_enabled = false
		boss_setup()
	)
	

func boss_setup():
	#setting the boss to active
	boss.setAwake(true)
