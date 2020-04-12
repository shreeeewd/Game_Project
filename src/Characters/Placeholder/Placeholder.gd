extends KinematicBody2D

var dashSpeed: = 1000.0
var walkSpeed:= 300.0
var dashPossible:= false
var dash: bool

var airSpeed:= 50.0
var airLim:= false

var jumpHeight:= -1000.0
var doubleJumpHeight:= -1350.0
var jumpCount:= 2

var gravity:= 3000
var gravLim:= false

var upSpecialSpeed:= -3000
var sideSpecialSpeed:= 1500.0
var sideSpecialCount:= 0
var upSpecialCount:= 0

var fastFall: = false
var onGround: bool 
const FLOOR_NORMAL: = Vector2.UP

var crouching: bool
var crouch: bool
var idle:= true

onready var kirito = get_node("Kirito")

var velocity:= Vector2()

func get_input():
	#Basic Movement
		#Left Right Movement
		if velocity.y == 0:
			#Dash	
			if Input.is_action_pressed("move_left") && dashPossible == true || Input.is_action_pressed("move_right") && dashPossible == true:
				dash = true
				
				#Left
			if Input.is_action_pressed("move_left") && crouch == false && dash == false:
				velocity.x = -walkSpeed
				get_node('Kirito').set_scale(Vector2(-1, 1))
				
			elif Input.is_action_pressed("move_left") && crouch == false && dash == true:
				velocity.x = -dashSpeed
				get_node('Kirito').set_scale(Vector2(-1, 1))

				#Right
			elif Input.is_action_pressed("move_right") && crouch == false && dash == false:
				velocity.x = walkSpeed
				get_node('Kirito').set_scale(Vector2(1, 1))

			elif Input.is_action_pressed("move_right") && crouch == false && dash == true:
				velocity.x = dashSpeed
				get_node('Kirito').set_scale(Vector2(1, 1))


			#Slowdown
			else:
				if velocity.x > 0:
					velocity.x = velocity.x - 100
				elif velocity.x < 0:
					velocity.x = velocity.x + 100
		else: #Aerial Left/Right
			if Input.is_action_pressed("move_left"):
				velocity.x -= airSpeed
			elif Input.is_action_pressed("move_right"):
				velocity.x += airSpeed
			else:
				if velocity.x > 0:
					velocity.x = velocity.x - 50
				elif velocity.x < 0:
					velocity.x = velocity.x + 50
	
		#Jump
		if Input.is_action_just_pressed("jump") && jumpCount == 2:
			velocity.y = jumpHeight
			jumpCount = 1
			onGround = false
			fastFall = false
		elif Input.is_action_just_pressed("jump") && jumpCount == 1:
				velocity.y = doubleJumpHeight
				jumpCount = 0
				onGround = false
				fastFall = false
				velocity.x = 0
				airSpeed = 75.0
	
		#Crouch/FastFall
		if Input.is_action_pressed("down") && onGround == true:
			velocity = Vector2(0,0)
			crouch = true
		elif Input.is_action_just_pressed("down") && onGround == false  && fastFall == false:
				velocity.y = velocity.y + 500
				fastFall = true
		
		if crouch == true:
			if Input.is_action_just_pressed("left"):
				get_node('Kirito').set_scale(Vector2(-1, 1))
			elif Input.is_action_just_pressed("right"):
				get_node('Kirito').set_scale(Vector2(1, 1))

		if Input.is_action_just_released("down") || onGround == false || velocity.y != 0:
			crouch = false
		
	
		#Specials
			#Recovery
				#Up Special
		if Input.is_action_pressed("up") && Input.is_action_just_pressed("special") && upSpecialCount == 0:
			velocity.y = upSpecialSpeed
			fastFall = false
			upSpecialCount = 1
		
		if velocity.y != 0:		#Side Specials
			if Input.is_action_pressed("right") && Input.is_action_just_pressed("special") && sideSpecialCount == 0:
				velocity.x = sideSpecialSpeed
				velocity.y = jumpHeight
				fastFall = false
				sideSpecialCount = 1
				get_node('Kirito').set_scale(Vector2(1, 1))

			elif Input.is_action_pressed("left") && Input.is_action_just_pressed("special") && sideSpecialCount == 0:
					velocity.x = -sideSpecialSpeed
					velocity.y = jumpHeight
					fastFall = false
					sideSpecialCount = 1
					get_node('Kirito').set_scale(Vector2(-1, 1))

		else:
			if Input.is_action_pressed("right") && Input.is_action_just_pressed("special"):
				velocity.y = jumpHeight/2
				velocity.x = sideSpecialSpeed
				get_node('Kirito').set_scale(Vector2(1, 1))

			elif Input.is_action_pressed("left") && Input.is_action_just_pressed("special"):
					velocity.x = -sideSpecialSpeed
					velocity.y = jumpHeight/2
					get_node('Kirito').set_scale(Vector2(-1, 1))




		#Reset Things
		if is_on_floor():
			onGround = true
			jumpCount = 2
			sideSpecialCount = 0
			upSpecialCount = 0
			airSpeed = 10.0
			dash = false
		else: #not on floor
			onGround = false
			if jumpCount == 2 && velocity.y != 0:
				jumpCount = 1
				onGround = false

		if Input.is_action_just_released("left") || Input.is_action_just_released("right"):
			dash = false		
		if Input.is_action_just_released("left") && velocity.x != 0|| Input.is_action_just_released("right") && velocity.x != 0:
			dashPossible = true
		elif velocity.x == 0:
			dashPossible = false
			dash = false

			

		#Gravity
		if onGround == false && gravLim == false:
			velocity.y = velocity.y + (gravity * get_physics_process_delta_time())

		if velocity.y >= 4000.0:
			velocity.y = 4000.0
			gravLim = true
		else:
			gravLim = false
		
		if onGround == false:
			if velocity.x >= 1500:
				airLim = true
				velocity.x = 1500
			elif velocity.x <= -1500:
				airLim = true
				velocity.x = -1500
	
				
func _physics_process(_delta: float) -> void:
	get_input()

	velocity = move_and_slide(velocity,FLOOR_NORMAL)
