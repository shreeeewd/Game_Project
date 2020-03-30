extends Node2D


func _process(delta: float) -> void:

    if Input.is_action_just_pressed("special"):
        get_tree().change_scene("res://src/Hud-MenuElements/Menu.tscn")