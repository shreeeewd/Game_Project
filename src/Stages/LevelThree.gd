extends Node2D

var transitionIn:= false

func _process(delta: float) -> void:
	if transitionIn == false:
		get_node("AnimationPlayer").play("fadeIn")
		transitionIn = true
		
	if Input.is_action_just_pressed("menu_back"):
		get_node("AnimationPlayer").play("fade")


func _on_Victory_area_entered(area: Area2D) -> void:
	get_node("AnimationPlayer").play("misc")


func _on_deathbarrier_area_entered(area: Area2D) -> void:
	get_node("AnimationPlayer").play("death")
