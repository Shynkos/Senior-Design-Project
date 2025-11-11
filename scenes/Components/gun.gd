extends Sprite2D

@onready var marker_2d: Marker2D = $Marker2D
const BULLET = preload("res://scenes/Components/bullet.tscn")
var wants_to_fire = false
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	if global_rotation_degrees<-90 or global_rotation_degrees>90:
		$Sprite2D.flip_v=true
	else:
		$Sprite2D.flip_v=false
	
func fire(player_velocity: Vector2, delta) -> void:
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = marker_2d.global_position
	print(new_bullet.global_position, " ", marker_2d.global_position)
	new_bullet.rotation = marker_2d.global_rotation
	new_bullet.target_position = (get_global_mouse_position() - marker_2d.global_position).normalized()
	new_bullet.player_velocity = player_velocity
	get_tree().current_scene.add_child(new_bullet)
	
