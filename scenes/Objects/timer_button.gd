extends Area2D

@onready var animated_sprite = $AnimatedSprite2D

@export var switch_timer: Timer
signal toggled(active: bool)

var switch = false

func interact():
	if not switch_timer:
		push_warning("missing timer")
		return
	
	if !switch:
		print("switched")
		switch = true
		switch_timer.start()
		animated_sprite.play("switch_on")

func _ready():
	add_to_group("Interactable")
	if switch_timer:
		switch_timer.timeout.connect(_on_timer_end)
		
func _on_timer_end():
	switch = false
	animated_sprite.play("switch_off")
