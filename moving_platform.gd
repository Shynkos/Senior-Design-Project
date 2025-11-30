extends Path2D

@export var loop = true
@export var speed = 2.0
@export var speed_scale = 1.0
@export var timer: Timer

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer

func _ready() -> void:
	animation.speed_scale = speed_scale

func _process(delta: float) -> void:
	if timer:
		if not loop:
			if timer.time_left>0.0:
				if !animation.is_playing():
					animation.play("move")
			else:
				if animation.is_playing():
					animation.stop()
		else:
			if timer.time_left>0.0:
				path.progress += speed
	else:
		if not loop:
			if !animation.is_playing():
				animation.play("move")
		else:
			path.progress += speed
