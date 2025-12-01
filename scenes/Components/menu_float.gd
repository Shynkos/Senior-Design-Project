extends Label

var float_height = 10
var speed = 2
var base_y = 0

func _ready():
	base_y = position.y

func _process(delta):
	position.y = base_y + sin(Time.get_ticks_msec() / 800.0 * speed) * float_height
