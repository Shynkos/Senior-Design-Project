extends Node2D


@export var Player: Node2D
signal PlayerEntered


func _on_area_2d_body_entered(body: Node2D):
	PlayerEntered.emit(body)


func _on_boss_attack_1():
	position.x = Player.position.x
