extends Area2D

@export var speed = 300
var target_position = 1
var despawn_time = 1

func _ready() -> void:
	var timer = get_node("Timer")
	timer.timeout.connect(despawn)



func _physics_process(delta: float) -> void:
	position += target_position * (speed * delta)

func despawn() -> void:
	queue_free()
