extends Sprite2D

var amplitude := 10
var duration := 1.5

func _ready():
	float_loop()

func float_loop():
	var start_y = position.y
	var end_y = start_y - amplitude

	var tween = create_tween()
	tween.tween_property(self, "position:y", end_y, duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(self, "position:y", start_y, duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.set_loops()  # makes repeat 
