extends CharacterBody2D


signal attack1
var health = 100
var speed = 100
@export var Player: Node2D
@onready var nav = $NavigationAgent2D as NavigationAgent2D


func _physics_process(_delta):
	var direction = to_local(nav.get_next_path_position()).normalized().x
	velocity.x = direction * speed
	pathfinding()
	move_and_slide()


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
