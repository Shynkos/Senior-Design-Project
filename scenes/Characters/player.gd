extends CharacterBody2D


var fire_cooldown = 0.0
var wants_to_fire = false
@export var fire_delay = 0.2
@onready var animated_sprite = $AnimatedSprite2D

# gravity and jump velocity
@export var gravity = 2000.0
@export var jump_vel = -800.0
var on_ground = true
var SpikeScene = preload("res://scenes/Components/spike.tscn")

var jump = false
var is_hit = false
var knockback_velocity = Vector2.ZERO

#health
@export var MaxHealth: int = 5
var health: int = MaxHealth

# preloading projectile
@export var bullet: PackedScene
func Attack(delta):
	get_node("Gun").fire(velocity, delta)


func _process(delta):
	if Input.is_action_just_pressed("Pause") and !$ControlsMenu.visible and !$VideoMenu.visible and !$GameOverMenu.visible:
		get_tree().paused = true
		$PauseMenu.visible = !$PauseMenu.visible
	
	# register attacks
	if not is_hit:
		if Input.is_action_just_pressed("Fire"):
			wants_to_fire = true
		
	if fire_cooldown > 0.0:
		fire_cooldown -= delta
	elif wants_to_fire and not is_hit:
		Attack(delta)
		fire_cooldown = fire_delay
		wants_to_fire = false


#enemy damage
func _on_hurtbox_body_entered(body: Node2D):	
	if not $Timers/InvulnTimer.time_left:
		if body.is_in_group("Enemies"):
			take_damage(body)


func take_damage(source: Node2D):
	health -= 1
	if health == 0:
		# decrease healthbar
		$HUD.hearts[health].visible = false
		
		#player dies
		death()
	elif health > 0:
		var direction = sign(global_position.x - source.global_position.x)
		
		knockback_velocity = Vector2(300 * direction, -400)
		velocity = knockback_velocity
		is_hit = true
		
		#decrease healthbar
		$HUD.hearts[health].visible = false
		
		$Timers/InvulnTimer.start()
		flash([$AnimatedSprite2D])
		#play damage noise
		

func death():
	$GameOverMenu.visible = true


func _physics_process(delta):
	#cleaning up
	if is_hit:
		handle_knockback(delta)
	else:
		handle_movement(delta)
	on_ground = is_on_floor()
	move_and_slide()
	
	if is_on_floor():
		is_hit = false
		jump = false
	if not is_hit and not is_on_floor() and on_ground:
		$Timers/Coyote.start()


func handle_knockback(delta):
	velocity.y += gravity * delta
	velocity.x = lerp(velocity.x, 0.0, delta * 3.0)


func handle_movement(delta):
		# get key input from user
	var direction = Input.get_axis("Move left", "Move right")
	
	# update horizontal velocity based on direction
	velocity.x = 500 * direction
	
	
	# gravity
	velocity.y += gravity * delta
	
	# jump if user presses space
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or $Timers/Coyote.time_left):
		velocity.y = jump_vel
		jump = true
	
	handle_movement_animation(direction)


func handle_movement_animation(dir):
	if on_ground:
		if abs(velocity.x) < 0.1:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
			toggle_flip_sprite(dir)
	elif jump:
		animated_sprite.play("jump")
		toggle_flip_sprite(dir)

# make character sprite face correct direction
func toggle_flip_sprite(dir):
	if dir == 1: # moving right
		animated_sprite.flip_h = false
	if dir == -1: # moving left
		animated_sprite.flip_h = true


func _on_pause_menu_options():
	$OptionsMenu.visible = true


func _on_options_menu_back():
	$PauseMenu.visible = true


func _on_options_menu_controls():
	$ControlsMenu.visible = true


func _on_controls_menu_back():
	$OptionsMenu.visible = true


func _on_video_menu_back():
	$OptionsMenu.visible = true


func _on_options_menu_video():
	$VideoMenu.visible = true


func _on_pause_menu_pause():
	get_tree().paused = false


func _on_options_menu_pause():
	$PauseMenu.visible = true

	
func _on_boss_attack_1():
	var spikes = SpikeScene.instantiate()
	spikes.position.x = position.x
	add_sibling(spikes)


func flash(nodes):
	var tween = create_tween()
	tween.tween_method(set_flash_value.bind(nodes), 0.0, 1.0, 0.1).set_trans(Tween.TRANS_QUAD)
	tween.tween_method(set_flash_value.bind(nodes), 1.0, 0.0, 0.4).set_trans(Tween.TRANS_QUAD)


func set_flash_value(value: float, nodes):
	for node in nodes:
		node.material.set_shader_parameter('Progress', value)
