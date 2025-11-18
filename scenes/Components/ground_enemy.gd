extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

#enemy stats
@export var health: int = 25


# placeholder simple movement code borrowed from https://forum.godotengine.org/t/enemy-movement-controll/75581/2
var direction = 1
var start_position = 0
@export var walking_distance = 100
@export var speed = 50

func _ready():
	add_to_group("Enemies")
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

#damage system
func take_damage(amount):
	#get damage animation
	var nodes = [$AnimatedSprite2D] 
	flash(nodes)
	health -= amount
	if health <= 0:
		die()

func die():
	#get death animation
	queue_free()

func flash(nodes):
	var tween = create_tween()
	tween.tween_method(set_flash_value.bind(nodes), 0.0, 1.0, 0.1).set_trans(Tween.TRANS_QUAD)
	tween.tween_method(set_flash_value.bind(nodes), 1.0, 0.0, 0.4).set_trans(Tween.TRANS_QUAD)

func set_flash_value(value: float, nodes):
	for node in nodes:
		node.material.set_shader_parameter('Progress', value)
