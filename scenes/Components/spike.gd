extends Node2D

@export var damage: int = 5

var active = false
var entered = false
var Player: CharacterBody2D = null


func _on_self_destruct_timeout():
	queue_free()


func _on_particle_timer_timeout():
	$Particles.emitting = false
	$SpikeTexture.visible = true
	active = true
	if entered:
		Player.take_damage($Area2D)


func _on_area_2d_body_entered(body: Node2D):
	if body.name == "Player":
		entered = true
		Player = body
		if active:
			body.take_damage($Area2D)



func _on_area_2d_body_exited(body: Node2D):
	if body.name == "Player":
		entered = false
