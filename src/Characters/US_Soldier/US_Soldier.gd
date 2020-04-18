extends StaticBody2D


func _physics_process(delta: float) -> void:
	get_node("AnimationPlayer").play("gun")

func _on_Hitbox_area_entered(area: Area2D) -> void:
	get_node("AnimationPlayer").play("hit")
	queue_free()
