extends Area2D
signal Damage


func _on_area_entered(area: Area2D):
	if area.name == "SpikeHitbox" and area.get_parent().active == true:
		Damage.emit()
