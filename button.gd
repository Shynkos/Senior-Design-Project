extends Sprite2D

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
	frame = 8
	print("test2")
	if get_parent().has_method("push_button"):
		print("confirm")
		get_parent().push_button(get_index())

func unpressed():
	frame = 9
	print("test")
	if get_parent().has_method("push_button"):
		print("confirm")
		get_parent().push_button(get_index())
