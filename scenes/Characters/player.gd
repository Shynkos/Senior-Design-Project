extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

# gravity and jump velocity
@export var gravity = 2000.0
@export var jump_vel = -800.0
var on_ground = true
# preloading projectile

@export var bullet: PackedScene
func Attack():
	if Input.is_action_just_pressed("Fire"):
		get_node("Gun").fire()

func _process(delta):
	if Input.is_action_just_pressed("Pause") and !$ControlsMenu.visible:
		$PauseMenu.visible = !$PauseMenu.visible

func _physics_process(delta):
	# get key input from user
	var direction = Input.get_axis("Move left", "Move right")
	
	# update horizontal velocity based on direction
	velocity.x = 500 * direction
	
	# update boolean if player is on the ground
	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
		
	# gravity
	velocity.y += gravity * delta
	
	# jump if user presses space
	if Input.is_action_just_pressed("Jump") and on_ground:
		velocity.y = jump_vel
	# register attacks
	Attack();
	move_and_slide()
	handle_movement_animation(direction)

func handle_movement_animation(dir):
	if on_ground:
		if !velocity:
			animated_sprite.play("idle")
		if velocity:
			animated_sprite.play("run")
			toggle_flip_sprite(dir)
	elif !on_ground:
		animated_sprite.play("jump")
		toggle_flip_sprite(dir)

# make character sprite face correct direction
func toggle_flip_sprite(dir):
	if dir == 1: # moving right
		animated_sprite.flip_h = false
	if dir == -1: # moving left
		animated_sprite.flip_h = true


func _on_pause_menu_options():
	$OptionsMenu.visible = visible



func _on_options_menu_back():
	$PauseMenu.visible = visible



func _on_options_menu_controls():
	$ControlsMenu.visible = visible


func _on_controls_menu_back():
	$OptionsMenu.visible = visible
