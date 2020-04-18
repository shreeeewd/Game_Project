extends StaticBody2D



func _on_Hitbox_area_entered(area: Area2D) -> void:
	get_node("AnimationPlayer2").play("break")
	queue_free()
