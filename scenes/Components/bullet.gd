extends Area2D

@export var damage: int = 5
@export var speed: float = 600
@export var inherit_factor: float = 0.2

var target_position: Vector2
var despawn_time = 1
var player_velocity: Vector2 = Vector2.ZERO 
func _ready() -> void:
	var timer = get_node("Timer")
	timer.timeout.connect(despawn)



func _physics_process(delta: float) -> void:
	move_local_x(target_position.x * speed * delta)
	move_local_y(target_position.y* speed * delta)
	

func despawn() -> void:
	queue_free()


#if it hits an enemy do damage then despawn otherwise just despawn
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		print("enemy hit")
		body.take_damage(damage)
		despawn()
	elif body.is_in_group("ground"):
		despawn()
