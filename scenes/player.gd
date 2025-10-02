extends CharacterBody2D

# gravity and jump velocity
@export var gravity = 2000.0
@export var jump_vel = -800.0
var on_ground = true

func _physics_process(delta):
	# get key input from user
	var direction = Input.get_vector("Move left", "Move right", "", "")
	
	# update horizontal velocity based on direction
	velocity.x = 500 * direction.x
	
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
	
	move_and_slide()	
