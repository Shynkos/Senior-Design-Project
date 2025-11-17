extends Area2D

@onready var animated_sprite = $AnimatedSprite2D

var switch = false:
	set(value):
		switch = value
		if value == true:
			pressed()
		else:
			unpressed()

func interact():
	switch = not switch

func pressed():
	print("test2")
	if get_parent().has_method("push_button"):
		print("confirm")
		get_parent().push_button(get_index())
		animated_sprite.play("switch_on")

func unpressed():
	print("test")
	if get_parent().has_method("push_button"):
		print("confirm")
		get_parent().push_button(get_index())
		animated_sprite.play("switch_off")
