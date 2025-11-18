extends Node2D

@export var door : TileMapLayer
@export var doorTileRange : Array[Vector2i] = []
@export var button_order : Array[int]
@export var doorTile : Vector2i
@export var doorChange: Area2D

var arr = []
var is_open = false
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
	doorTile = door.get_cell_atlas_coords(doorTiles[0])



func push_button(value):
	if door == null:
		return
	
	
	#add button to code
	if not arr.has(value):
		arr.append(value)
	else:
		arr.erase(value)
	
	print(arr)

	print(arr, " and ", button_order)
	if arr == button_order:
		if not is_open:
			print("called")
			for pos in doorTiles:
				door.erase_cell(pos) 
			doorChange.visible = true
			is_open = true
	else:
		if is_open:
			for pos in doorTiles:
				door.set_cell(pos,0, doorTile, TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_V) 
		doorChange.visible = false
		is_open = false
