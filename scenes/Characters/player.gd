extends CharacterBody2D

var fire_cooldown = 0.0
var wants_to_fire = false
@export var fire_delay = 0.2
@onready var animated_sprite = $AnimatedSprite2D
@export var player_speed: float = 400.0
# gravity and jump velocity
@export var gravity = 2000.0
@export var jump_vel = -800.0
var on_ground = true
var in_hitbox = false
var enemybody: Node2D = null
# audio
@onready var footstep_sound: AudioStreamPlayer2D = $FootstepSound
@export var step_interval := 0.22
var step_timer := 0.0

var jump = false
var is_hit = false
var is_dead = false
var knockback_velocity = Vector2.ZERO
#health

# preloading projectile
@export var bullet: PackedScene
func Attack(delta):
	get_node("Gun").fire(velocity, delta)


func _ready():
	PlayerGlobal.position = position
	add_to_group("player")
	if RoomChangeGlobal.Activate:
		global_position = RoomChangeGlobal.PlayerPos
		if RoomChangeGlobal.PlayerJumpOnEnter:
			velocity.y = jump_vel
		RoomChangeGlobal.Activate = false


func _input(_event):
	if Input.is_action_just_pressed("Pause") and !$Menus/ControlsMenu.visible and !$Menus/VideoMenu.visible and !$Menus/GameOverMenu.visible:
		get_tree().paused = true
		$Menus/PauseMenu.visible = !$Menus/PauseMenu.visible

	#interactable
	#revamping interaction system
	if Input.is_action_just_pressed("Interact"):
		print("interact")
		for n in $InteractionBox.get_overlapping_areas():
			if n.is_in_group("Interactable"):
				print("pushed")
				n.interact()
	

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
		
	if in_hitbox:
		take_damage(enemybody)


#enemy damage
func _on_hurtbox_body_entered(body: Node2D):	
	if body.is_in_group("Enemies"):
		in_hitbox = true
		enemybody = body


func _on_hurtbox_body_exited(body: Node2D):
	if body.is_in_group("Enemies"):
		in_hitbox = false
		enemybody = null


func take_damage(source: Node2D):
	if not $Timers/InvulnTimer.time_left:
		PlayerGlobal.Health -= 1
		if PlayerGlobal.Health == 0:
			# decrease healthbar
			$HUD.hearts[PlayerGlobal.Health].visible = false
			
			#player dies
			death()
		elif PlayerGlobal.Health > 0:
			var direction = sign(global_position.x - source.global_position.x)
			
			knockback_velocity = Vector2(300 * direction, -400)
			velocity = knockback_velocity
			is_hit = true
			
			#decrease healthbar
			$HUD.hearts[PlayerGlobal.Health].visible = false
			
			$Timers/InvulnTimer.start()
			flash([$AnimatedSprite2D])
			#play damage noise


func death():
	is_dead = true
	$Menus/GameOverMenu.visible = true
	$Menus/GameOverMenu.visible = true


func _physics_process(delta):
	if is_hit or is_dead:
		handle_knockback(delta)
	else:
		handle_movement(delta)
	
	on_ground = is_on_floor()
	move_and_slide()
	PlayerGlobal.position = position
	
	if is_on_floor():
		is_hit = false
		jump = false
	
	if not is_hit and not is_on_floor() and on_ground:
		$Timers/Coyote.start()
	
	# footsteps
	if is_on_floor() and abs(velocity.x) > 0.1:
		step_timer -= delta
		if step_timer <= 0:
			footstep_sound.play()
			step_timer = step_interval
	else:
		step_timer = step_interval


func handle_knockback(delta):
	velocity.y += gravity * delta
	velocity.x = lerp(velocity.x, 0.0, delta * 3.0)


func handle_movement(delta):
		# get key input from user
	var direction = Input.get_axis("Move left", "Move right")
	
	# update horizontal velocity based on direction
	velocity.x = player_speed * direction
	
	
	# gravity
	velocity.y += gravity * delta
	
	# jump if user presses space
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or $Timers/Coyote.time_left) and jump == false:
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
	$Menus/OptionsMenu.visible = true


func _on_options_menu_back():
	$Menus/PauseMenu.visible = true


func _on_options_menu_controls():
	$Menus/ControlsMenu.visible = true


func _on_controls_menu_back():
	$Menus/OptionsMenu.visible = true


func _on_video_menu_back():
	$Menus/OptionsMenu.visible = true


func _on_options_menu_video():
	$Menus/VideoMenu.visible = true
	$Menus/OptionsMenu.visible = true


func _on_pause_menu_pause():
	get_tree().paused = false


func _on_options_menu_pause():
	$Menus/PauseMenu.visible = true


func flash(nodes):
	var tween = create_tween()
	tween.tween_method(set_flash_value.bind(nodes), 0.0, 1.0, 0.1).set_trans(Tween.TRANS_QUAD)
	tween.tween_method(set_flash_value.bind(nodes), 1.0, 0.0, 0.4).set_trans(Tween.TRANS_QUAD)


func set_flash_value(value: float, nodes):
	for node in nodes:
		node.material.set_shader_parameter('Progress', value)


func _on_game_over_menu_respawn():
	is_dead = false
	PlayerGlobal.Health = PlayerGlobal.MaxHealth
