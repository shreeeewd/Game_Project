extends Node2D

var yes:= 0
var transitionIn:= false

func _process(_delta: float) -> void:
	if transitionIn == false:
		get_node("AnimationPlayer2").play("fadeIn")
		get_node("AnimationPlayer3").play("Logo")
		transitionIn = true
	
	if Input.is_action_just_pressed("special") || Input.is_action_just_pressed("start"):
		get_node("AnimationPlayer").play("fadeOut")
		yes = yes + 1
	elif yes == 0:
		get_node("AnimationPlayer").play("musicEnter")

