extends Sprite2D


@onready var marker_2d: Marker2D = $Marker2D
@onready var spawnpoint: Marker2D = $Spawnpoint
@onready var y_location = $Spawnpoint.position.y


const BULLET = preload("res://scenes/Components/bullet.tscn")
var wants_to_fire = false


func _process(_delta: float):
	look_at(get_global_mouse_position())
	if global_rotation_degrees <- 90 or global_rotation_degrees > 90:
		$Sprite2D.flip_v = true
		spawnpoint.position.y = -y_location
		marker_2d.position.y = -y_location
	else:
		$Sprite2D.flip_v = false
		spawnpoint.position.y = y_location
		marker_2d.position.y = y_location
	
func fire(player_velocity: Vector2, _delta):
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = spawnpoint.global_position
	#print(new_bullet.global_position, " ", marker_2d.global_position)
	
	new_bullet.rotation = marker_2d.global_rotation
	new_bullet.target_position = (marker_2d.global_position - spawnpoint.global_position).normalized()
	new_bullet.player_velocity = player_velocity
	get_tree().current_scene.add_child(new_bullet)
