extends Node2D

var selection: Vector2
var storySelected: bool
var versusSelected: bool
var controlsSelected: bool

onready var versusSprite = get_node("versusSprite")
onready var storySprite = get_node("storySprite")
onready var controlsSprite = get_node("controlsSprite")

var versusInactive = preload("res://Assets/HUD-Menu/MainMenu/Versus/smashMenu.png")
var versusActive = preload("res://Assets/HUD-Menu/MainMenu/Versus/smashMenuActive.png")

var storyInactive = preload("res://Assets/HUD-Menu/MainMenu/Story/story.png")
var storyActive = preload("res://Assets/HUD-Menu/MainMenu/Story/storyActive.png")

var controlsInactive = preload("res://Assets/HUD-Menu/MainMenu/Options/gamecube.png")
var controlsActive = preload("res://Assets/HUD-Menu/MainMenu/Options/gamecubeActive.png")


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("right"):
		selection.x = 1
	elif Input.is_action_just_pressed("left"):
		selection.x = 0
	elif Input.is_action_just_pressed("up"):
		selection.y = 1
	elif Input.is_action_just_pressed("down"):
		selection.y = 0

	if selection.x == 1:
		controlsSelected = true
	else:
		controlsSelected = false
	
	if selection == Vector2(0,1):
		versusSelected = true
	else: 
		versusSelected = false
	
	if selection == Vector2(0,0):
		storySelected = true
	else:
		storySelected = false



	if versusSelected == true:
		versusSprite.set_texture(versusActive)
	else: 
		versusSprite.set_texture(versusInactive)

	if storySelected == true:
		storySprite.set_texture(storyActive)
	else:
		storySprite.set_texture(storyInactive)

	if controlsSelected == true:
		controlsSprite.set_texture(controlsActive)
	else: 
		controlsSprite.set_texture(controlsInactive)
	
		
