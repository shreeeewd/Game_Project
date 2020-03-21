extends KinematicBody2D


export var speed:= 1000.0
export var gravity:= 20
export var jumpHeight:= -500.0
export var jumpCount:= 2

const FLOOR_NORMAL: = Vector2.UP

var velocity = Vector2()
#var onGround = true


func _physics_process(delta: float):
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
	elif Input.is_action_pressed("move_right"):
		velocity.x = speed
	else:
		if velocity.x > 0:
			velocity.x = velocity.x - 50
		elif velocity.x < 0:
			velocity.x = velocity.x + 50

	if Input.is_action_just_pressed("jump"):
		velocity.y = jumpHeight
#		if jumpCount < 0:
#			jumpCount -= jumpCount
#			velocity.y = jumpHeight
#			onGround = false
#		elif jumpCount == 0:
#			pass

#		if onGround == true:
#			velocity.y = jumpHeight
#			onGround = false

	velocity.y += gravity
	
	velocity = move_and_slide(velocity, FLOOR_NORMAL)

#	if is_on_floor():
#		onGround = true
#	else: 
#		onGround = false











