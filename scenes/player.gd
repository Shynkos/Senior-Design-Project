extends CharacterBody2D

# gravity and jump velocity
@export var gravity = 2000.0
@export var jump_vel = -800.0
var on_ground = true
# preloading projectile

@export var bullet: PackedScene
func Attack():
	if Input.is_action_just_pressed("Fire"):
		get_node("Gun").fire()

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
