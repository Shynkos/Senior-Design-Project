extends Control

@export var float_height := 20          # how far text floats up/down
@export var float_duration := 2.0       # speed of float
@export var total_time := 10.0          # time before fade-out starts
@export var fade_time := 1.5            # fade in/out speed
@export_file("*.tscn") var menu_scene   # drag Menu.tscn here

func _ready():
	modulate.a = 0.0        # start invisible
	fade_in()
	start_float()
	end_after_delay()

# Fade in smoothly
func fade_in():
	var t = create_tween()
	t.tween_property(self, "modulate:a", 1.0, fade_time)\
	 .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

# Floating loop function
func start_float():
	float_cycle()

func float_cycle():
	var tw = create_tween()
	tw.tween_property(self, "position:y", position.y - float_height, float_duration)\
	  .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(self, "position:y", position.y + float_height, float_duration)\
	  .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tw.finished.connect(float_cycle)   # loops forever until fade-out
										 
# Fade-out → return to menu
func end_after_delay():
	await get_tree().create_timer(total_time).timeout

	var f = create_tween()
	f.tween_property(self, "modulate:a", 0.0, fade_time)\
	  .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await f.finished

	get_tree().change_scene_to_file(menu_scene)
