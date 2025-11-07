extends Node2D


signal PlayerEntered
var active = false


func _on_area_2d_body_entered(body: Node2D):
	if body.name == "Player":
		PlayerEntered.emit()


func _on_self_destruct_timeout():
	queue_free()


func _on_particle_timer_timeout():
	$Particles.emitting = false
	$SpikeTexture.visible = true
	active = true
