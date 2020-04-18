extends Node2D

func _on_TopLevel_area_entered(area: Area2D) -> void:
	get_node("AnimationPlayer").play("Level2")
	
func _on_BottomLevel_area_entered(area: Area2D) -> void:
	get_node("AnimationPlayer").play("Level3")

func _on_BottomDeath_area_entered(area: Area2D) -> void:
	get_node("AnimationPlayer").play("Death")
