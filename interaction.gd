extends Area2D

var can_interact = false:
	set(value):
		can_interact = value
	




func _on_body_entered(body: Node2D) -> void:
		can_interact = true
		print("entered")



func _on_body_exited(body) -> void:
	can_interact = false
	
	
func interaction():
	owner.interact()
	
func _input(event):
	if event.is_action_pressed("Interact") and can_interact:
		interaction()  
