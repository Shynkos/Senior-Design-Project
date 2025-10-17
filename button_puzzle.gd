extends Node2D

@export var door : TileMapLayer
@export var door_tiles: Array[Vector2i] = []
@export var button_order : Array[int]

var arr = []
var is_open = false

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
				door.set_cell(pos,0, Vector2i(0,0)) # 5 is tile number to replace with
		is_open = false
