extends Node2D

var anim:= false

func _physics_process(delta: float) -> void:
	if anim == false:
		get_node("AnimationPlayer").play("BackgroundAnimation")
		anim = true
