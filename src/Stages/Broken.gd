extends StaticBody2D



func _on_Hitbox_area_entered(area: Area2D) -> void:
	queue_free()
