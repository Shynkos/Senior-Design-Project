extends Node2D

@export var door : TileMapLayer
@export var door_tiles: Array[Vector2i] = []
@export var doorTileRange : Array[Vector2i] = []
@export var button_order : Array[int]
@export var button_order2 : Array[int]
@export var doorTile : Vector2i

var arr = []
var is_open = false
var is_open2 = false
# second door hacky solution
var doorTiles: Array[Vector2i] = []
func _ready() -> void:
	var minX = min(doorTileRange[0].x,doorTileRange[1].x)
	var minY = min(doorTileRange[0].y,doorTileRange[1].y)
	var maxX = max(doorTileRange[0].x,doorTileRange[1].x)
	var maxY = max(doorTileRange[0].y,doorTileRange[1].y)
	for x in range(minX,maxX+1):
		for y in range(minY,maxY+1):
			doorTiles.append(Vector2i(x,y))



func push_button(value):
	if not arr.has(value):
		arr.append(value)
	else:
		arr.erase(value)
	
	print(arr)
	if door == null:
		return
	print(arr, " and ", button_order)
	if arr == button_order:
		if not is_open:
			print("called")
			for pos in door_tiles:
				door.erase_cell(pos) # 0 is layer
			is_open = true
	else:
		if is_open:
			for pos in door_tiles:
				door.set_cell(pos,0, doorTile) # 5 is tile number to replace with
		is_open = false
	if arr == button_order2:
		if not is_open2:
			print("called")
			for pos in doorTiles:
				door.erase_cell(pos) # 0 is layer
			is_open2 = true
	else:
		if is_open2:
			for pos in doorTiles:
				door.set_cell(pos,0, doorTile) # 5 is tile number to replace with
		is_open2 = false
