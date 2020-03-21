extends KinematicBody2D

var speed:= 1000.0
var airSpeed:= 500.0
var jumpHeight:= -2000.0
var gravity:= 0
var jumpCount: int
var onGround: bool 

const FLOOR_NORMAL: = Vector2.UP

var velocity:= Vector2()

func _physics_process(_delta: float) -> void:
    if onGround == true:
        if Input.is_action_pressed("move_left"):
	        velocity.x = -speed
        elif Input.is_action_pressed("move_right"):
            velocity.x = speed
        else:
            if velocity.x > 0:
	            velocity.x = velocity.x - 50
            elif velocity.x < 0:
                velocity.x = velocity.x + 50
                
    if onGround == false:
        if Input.is_action_pressed("move_left"):
	        velocity.x = -airSpeed
        elif Input.is_action_pressed("move_right"):
            velocity.x = airSpeed
        else:
            if velocity.x > 0:
	            velocity.x = velocity.x - 50
            elif velocity.x < 0:
                velocity.x = velocity.x + 50


    
    if is_on_floor():
        onGround = true
        jumpCount = 2
    else: #not on floor
        if jumpCount == 2:
            jumpCount = 1
            onGround = false

    if onGround == false:
        velocity.y = velocity.y + (gravity * get_physics_process_delta_time())
        
    if Input.is_action_just_pressed("jump") and jumpCount == 2:
        velocity.y = jumpHeight
        jumpCount = 1
        onGround = false
    elif Input.is_action_just_pressed("jump") and jumpCount == 1:
            velocity.y = jumpHeight
            jumpCount = 0
            onGround = false

    velocity = move_and_slide(velocity,FLOOR_NORMAL)
