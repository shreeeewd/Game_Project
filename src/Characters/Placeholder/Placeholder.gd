extends KinematicBody2D

var dashSpeed: = 1000.0
var walkSpeed:= 300.0
var dashPossible:= false

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
var recoverySpecials:= 0

var fastFall: = false
var freeFall:= false
var onGround: bool 
const FLOOR_NORMAL: = Vector2.UP

var face: String


#Impoertant Bools
var dash: bool
var idle: bool
var crouch: bool
var facingRight: bool
var jumpingGround: bool
var jumpingAir: bool
var facingLeft: bool


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
				facingRight = false
			elif Input.is_action_pressed("move_left") && crouch == false && dash == true:
				velocity.x = -dashSpeed
				facingRight = false

				#Right
			elif Input.is_action_pressed("move_right") && crouch == false && dash == false:
				velocity.x = walkSpeed
				facingRight = true
			elif Input.is_action_pressed("move_right") && crouch == false && dash == true:
				velocity.x = dashSpeed
				facingRight = true

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
		if Input.is_action_just_pressed("jump") && jumpCount == 2 && freeFall == false:
			velocity.y = jumpHeight
			jumpCount = 1
			onGround = false
			fastFall = false
		elif Input.is_action_just_pressed("jump") && jumpCount == 1 && freeFall == false:
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
		
		if Input.is_action_just_released("down"):
			crouch = false
		
	
		#Specials
			#Recovery
				#Up Special
		if Input.is_action_pressed("up") && Input.is_action_just_pressed("special") && freeFall == false:
			velocity.y = upSpecialSpeed
			fastFall = false
			recoverySpecials += 1
		
		if velocity.y != 0:		#Side Specials
			if Input.is_action_pressed("right") && Input.is_action_just_pressed("special") && sideSpecialCount == 0 && freeFall == false:
				velocity.x = sideSpecialSpeed
				velocity.y = jumpHeight
				fastFall = false
				sideSpecialCount = 1
				recoverySpecials += 1
				facingRight = true
			elif Input.is_action_pressed("left") && Input.is_action_just_pressed("special") && sideSpecialCount == 0 && freeFall == false:
					velocity.x = -sideSpecialSpeed
					velocity.y = jumpHeight
					fastFall = false
					sideSpecialCount = 1
					recoverySpecials += 1
					facingRight = false
		else:
			if Input.is_action_pressed("right") && Input.is_action_just_pressed("special"):
				velocity.y = jumpHeight/2
				velocity.x = sideSpecialSpeed
				facingRight = true
			elif Input.is_action_pressed("left") && Input.is_action_just_pressed("special"):
					velocity.x = -sideSpecialSpeed
					velocity.y = jumpHeight/2
					facingRight = false
					
		if recoverySpecials == 2:
			freeFall = true		


		#Reset Things
		if is_on_floor():
			onGround = true
			jumpCount = 2
			freeFall = false
			sideSpecialCount = 0
			recoverySpecials = 0
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
