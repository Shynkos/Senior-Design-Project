extends CharacterBody2D


var speed = 100
@export var Player: Node2D
@export var health: int = 1000
@onready var animated_sprite = $AnimatedSprite2D
@onready var nav = $NavigationAgent2D as NavigationAgent2D
var SpikeScene = preload("res://scenes/Components/spike.tscn")
var awake = false
#audio
@onready var hurt_sound: AudioStreamPlayer2D = $HurtSound
@onready var death_sound: AudioStreamPlayer2D = $DeathSound
@onready var gun_sound: AudioStreamPlayer2D = $GunSound

func _ready():
	#initalize health bar
	$HealthBar.value = 100


func _physics_process(_delta):
	if awake:
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
		var spikes = SpikeScene.instantiate()
		spikes.position.x = PlayerGlobal.position.x
		add_sibling(spikes)


#damage system
func take_damage(amount):
	#get damage animation
	var nodes = [$AnimatedSprite2D]
	flash(nodes)
	health -= amount
	
	if hurt_sound:
		hurt_sound.stop()
		hurt_sound.play()
	
	#update health bar
	$HealthBar.value = (float(health) / 1000) * 100
	
	if health <= 0:
		die()


func die():
	#get death animation
	if death_sound:
		death_sound.play()
		
	queue_free()
	get_tree().change_scene_to_file("res://scenes/Components/victory_menu.tscn")


func flash(nodes):
	var tween = create_tween()
	tween.tween_method(set_flash_value.bind(nodes), 0.0, 1.0, 0.1).set_trans(Tween.TRANS_QUAD)
	tween.tween_method(set_flash_value.bind(nodes), 1.0, 0.0, 0.4).set_trans(Tween.TRANS_QUAD)


func set_flash_value(value: float, nodes):
	for node in nodes:
		node.material.set_shader_parameter('Progress', value)
