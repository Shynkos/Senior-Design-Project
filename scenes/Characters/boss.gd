extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

signal attack1
@export var health: int = 1000
var speed = 100
@export var Player: Node2D
@onready var nav = $NavigationAgent2D as NavigationAgent2D


func _physics_process(_delta):
	var direction = to_local(nav.get_next_path_position()).normalized().x
	velocity.x = direction * speed
	pathfinding()
	move_and_slide()
	handle_movement_animation(direction)

func handle_movement_animation(dir):
	if !velocity:
		animated_sprite.play("idle")
	if velocity:
		animated_sprite.play("move")
		toggle_flip_sprite(dir)

# make character sprite face correct direction
func toggle_flip_sprite(dir):
	if dir < 0: # moving left
		animated_sprite.flip_h = false
	if dir > 0: # moving right
		animated_sprite.flip_h = true

func pathfinding():
	nav.target_position = Player.global_position


func _on_timer_timeout():
	speed = 100
	var random = randi_range(1, 5)
	
	if random == 1:
		speed = 300
	if random == 2:
		attack1.emit()


func _on_spike_player_entered(body: CharacterBody2D):
	if body == Player:
		print("Hit")


#damage system
func take_damage(amount):
	#get damage animation
	health -= amount
	if health <= 0:
		die()

func die():
	#get death animation
	queue_free()
