extends Control

func next() -> void:
	get_tree().change_scene("res://src/Hud-MenuElements/Menu.tscn")

func story() -> void:
	get_tree().change_scene("res://src/Hud-MenuElements/Story.tscn")

func versus() -> void:
	get_tree().change_scene("res://src/Hud-MenuElements/Versus.tscn")

func controls() -> void:
	get_tree().change_scene("res://src/Hud-MenuElements/Controls.tscn")    

func op() -> void:
	get_tree().change_scene("res://src/Hud-MenuElements/OpeningScreen.tscn")
 
