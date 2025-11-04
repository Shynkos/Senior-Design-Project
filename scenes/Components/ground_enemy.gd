extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

# placeholder simple movement code borrowed from https://forum.godotengine.org/t/enemy-movement-controll/75581/2
var direction = 1
var start_position = 0
var walking_distance = 100
var speed = 50

func _ready():
	start_position = position.x

func _physics_process(delta):
	position.x += direction * speed * delta
	
	if (position.x >= start_position + walking_distance):
		direction = -1

	if (position.x <= start_position - walking_distance):
		direction = 1
	
	handle_movement_animation(direction)

func handle_movement_animation(dir):
	if !speed:
		animated_sprite.play("idle")
	if speed:
		animated_sprite.play("run")
		toggle_flip_sprite(dir)

# make sprite face correct direction
func toggle_flip_sprite(dir):
	if dir == -1: # moving left
		animated_sprite.flip_h = false
	if dir == 1: # moving right
		animated_sprite.flip_h = true
