extends Area2D

@export var enabled = true
@export var door : TileMapLayer
@export var doorTileRange : Array[Vector2i] = []
@export var hitbox : CollisionShape2D

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
	if body.name == "Player" and enabled:
		for pos in doorTiles:
			door.set_cell(pos,0, Vector2i(11,1)) # 5 is tile number to replace with
		enabled = false
