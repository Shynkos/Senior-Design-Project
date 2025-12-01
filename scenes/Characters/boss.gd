extends CharacterBody2D


var speed = 100
@export var Player: Node2D
@export var health: int = 1000
@onready var animated_sprite = $AnimatedSprite2D
@onready var nav = $NavigationAgent2D as NavigationAgent2D
var SpikeScene = preload("res://scenes/Components/spike.tscn")
var awake = false
#audio
var maxHealth: int
@onready var hurt_sound: AudioStreamPlayer2D = $HurtSound
@onready var death_sound: AudioStreamPlayer2D = $DeathSound
@onready var gun_sound: AudioStreamPlayer2D = $GunSound
@onready var hitbox: CollisionShape2D = $CollisionShape2D
@onready var timer = $EventTimer


func _ready():
	#initalize health bar
	$HealthBar.value = 100
	maxHealth = health

func doDie():
	awake = false
	timer.stop()
	hitbox.set_deferred("disabled",true)
	$HealthBar.visible = false
	speed = 0
	velocity = Vector2.ZERO
	animated_sprite.stop()

func setAwake(value: bool):
	if value:
		animated_sprite.play("awake")
		await animated_sprite.animation_finished
	awake = value
	hitbox.disabled = !awake
	$HealthBar.visible = awake
	if awake and timer.is_stopped():
			timer.start()
	elif !awake:
		timer.stop()

func _physics_process(_delta):
	if awake and $AttackStall.is_stopped():

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
	var random = randi_range(1, 4)
	
	if random == 1 and speed != 0:
		speed = 300
	if random == 2:
		speed = 0
		animated_sprite.play("attack")
		$AttackStall.start()
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
	$HealthBar.value = (float(health) / maxHealth) * 100
	
	if health <= 0:
		die()


func die():
	#get death animation
	print("called death")
	doDie()
	animated_sprite.play("death")
	if death_sound:
		death_sound.play()
	await animated_sprite.animation_finished
	get_tree().change_scene_to_file("res://scenes/Components/victory_menu.tscn")
	queue_free()


func flash(nodes):
	var tween = create_tween()
	tween.tween_method(set_flash_value.bind(nodes), 0.0, 1.0, 0.1).set_trans(Tween.TRANS_QUAD)
	tween.tween_method(set_flash_value.bind(nodes), 1.0, 0.0, 0.4).set_trans(Tween.TRANS_QUAD)


func set_flash_value(value: float, nodes):
	for node in nodes:
		node.material.set_shader_parameter('Progress', value)


func _on_attack_stall_timeout():
	speed = 100
