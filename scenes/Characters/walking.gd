extends CharacterBody2D

@export var move_speed := 200
var is_walking_sound_playing = false

func _process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	velocity = input_vector.normalized() * move_speed

	if velocity.length() > 0:
		play_footsteps()
	else:
		stop_footsteps()

	move_and_slide()

func play_footsteps():
	if not $Footsteps.playing:
		$Footsteps.play()

func stop_footsteps():
	if $Footsteps.playing:
		$Footsteps.stop()
