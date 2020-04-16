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

var crouch:= false
var isCrouching:= false
var canRoll:= false
var isRolling:= false

var shield:= false
var isShielding:= false


var idle:= true
var facingRight:= true
var allow:= true

var percent: = 0.0
var canTakeDamage:= true

var velocity:= Vector2()

onready var kirito = get_node("Kirito")
onready var lifeBar = get_node("LifeBar")


var health1 = preload("res://Assets/Textures-Sprites/Actors/Kirito/Animations/HealthBar/health1.png")
var health2 = preload("res://Assets/Textures-Sprites/Actors/Kirito/Animations/HealthBar/health2.png")
var health3 = preload("res://Assets/Textures-Sprites/Actors/Kirito/Animations/HealthBar/health3.png")
var health4 = preload("res://Assets/Textures-Sprites/Actors/Kirito/Animations/HealthBar/health4.png")
var health5 = preload("res://Assets/Textures-Sprites/Actors/Kirito/Animations/HealthBar/health5.png")
var health6 = preload("res://Assets/Textures-Sprites/Actors/Kirito/Animations/HealthBar/health6.png")
var health7 = preload("res://Assets/Textures-Sprites/Actors/Kirito/Animations/HealthBar/health7.png")
var health8 = preload("res://Assets/Textures-Sprites/Actors/Kirito/Animations/HealthBar/health8.png")
var health9 = preload("res://Assets/Textures-Sprites/Actors/Kirito/Animations/HealthBar/health9.png")
var health10 = preload("res://Assets/Textures-Sprites/Actors/Kirito/Animations/HealthBar/health10.png")
var health11 = preload("res://Assets/Textures-Sprites/Actors/Kirito/Animations/HealthBar/health11.png")

func get_input():
	#Basic Movement
		#Left Right Movement
		if allow == true:	
			if velocity.y == 0:
				#Dash	
				if Input.is_action_pressed("move_left") && dashPossible == true || Input.is_action_pressed("move_right") && dashPossible == true:
					dash = true

					#Left
				if Input.is_action_pressed("move_left") && crouch == false && dash == false:
					velocity.x = -walkSpeed
					facingRight = false
					get_node("AnimationPlayer").play("Walk")

				elif Input.is_action_pressed("move_left") && crouch == false && dash == true:
					velocity.x = -dashSpeed
					facingRight = false

					#Right
				elif Input.is_action_pressed("move_right") && crouch == false && dash == false:
					velocity.x = walkSpeed
					facingRight = true
					get_node("AnimationPlayer").play("Walk")

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
			if Input.is_action_just_pressed("jump") && jumpCount == 2 && crouch == false:
				velocity.y = jumpHeight
				jumpCount = 1
				onGround = false
				fastFall = false
			elif Input.is_action_just_pressed("jump") && jumpCount == 1 && crouch == false:
					velocity.y = doubleJumpHeight
					jumpCount = 0
					onGround = false
					fastFall = false
					velocity.x = 0
					airSpeed = 75.0
			
			#Crouch/FastFall
			if Input.is_action_pressed("down") && velocity.y == 0:
				crouch = true		
			elif Input.is_action_just_pressed("down") && velocity.y != 0 && fastFall == false:
				velocity.y = velocity.y + 500
				fastFall = true


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
					facingRight = true

				elif Input.is_action_pressed("left") && Input.is_action_just_pressed("special") && sideSpecialCount == 0:
						velocity.x = -sideSpecialSpeed
						velocity.y = jumpHeight
						fastFall = false
						sideSpecialCount = 1
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
			

		
		if facingRight == true:
			get_node('Kirito').set_scale(Vector2(1, 1))
			get_node('CollisionBox').set_position(Vector2(29,-2))
			get_node('Hitbox').set_position(Vector2(29,-2))
			get_node('Jab').set_position(Vector2(107,-3))
		else:
			get_node('Kirito').set_scale(Vector2(-1, 1))
			get_node('CollisionBox').set_position(Vector2(-29,-2))
			get_node('Hitbox').set_position(Vector2(-29,-2))
			get_node('Jab').set_position(Vector2(-107,-3))
		
		#Cruching Continued...
		if crouch == true && isCrouching == false:
			get_node("AnimationPlayer").play("Crouch")
			velocity = Vector2(0,0)
			isCrouching = true
		

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
	

func healthbar():
	if Input.is_action_just_pressed("self_damage"):
		percent += 9

	if percent < 10:
		lifeBar.set_texture(health1)
	elif percent > 10 && percent < 20:
		lifeBar.set_texture(health2)
	elif percent > 20 && percent < 30:
		lifeBar.set_texture(health3)
	elif percent > 30 && percent < 40:
		lifeBar.set_texture(health4)
	elif percent > 40 && percent < 50:
		lifeBar.set_texture(health5)
	elif percent > 50 && percent < 60:
		lifeBar.set_texture(health6)
	elif percent > 60 && percent < 70:
		lifeBar.set_texture(health7)
	elif percent > 70 && percent < 80:
		lifeBar.set_texture(health8)
	elif percent > 80 && percent < 90:
		lifeBar.set_texture(health9)
	elif percent > 90 && percent < 100:
		lifeBar.set_texture(health10)
	elif percent > 100 && percent < 110:
		lifeBar.set_texture(health11)

func attacks():
	if shield == true && isShielding == false:
		get_node("AnimationPlayer").play("Shield")
		velocity = Vector2(0,0)
		isShielding = true
	
		
	
	if allow == true:
		if onGround == true:
			#Idle
			if velocity == Vector2(0,0) && crouch == false && idle == false && shield == false:
				get_node("AnimationPlayer").play("Idle")
				idle = true
			else:
				idle = false
			#Shield Shenanigans
			if Input.is_action_pressed("shield"):
				shield = true
			
			
			if Input.is_action_just_pressed("attack"):
				if idle == true:
					get_node("AnimationPlayer").play("Jab")
				elif Input.is_action_pressed("right") || Input.is_action_just_pressed("left"):
																									#get_node("AnimationPlayer").play("fTilt")
					pass
				elif Input.is_action_pressed("up"):
																									#get_node("AnimationPlayer").play("upTilt")
					pass
				elif Input.is_action_pressed("down"):
																									#get_node("AnimationPlayer").play("downTilt")
					pass

			if Input.is_action_just_pressed("c_up"):
																								#get_node("AnimationPlayer").play("upSmash")
				pass
			if Input.is_action_just_pressed("c_down"):
					#get_node("AnimationPlayer").play("downSmash")
				pass
			if Input.is_action_just_pressed("c_right"):
				facingRight = true
																								#get_node("AnimationPlayer").play("fSmash")
				pass
			if Input.is_action_just_pressed("c_left"):
				facingRight = false
																								#get_node("AnimationPlayer").play("fSmash")
				pass
					
		else:

			if Input.is_action_just_pressed("attack") && Input.is_action_pressed("down") == false && Input.is_action_pressed("left") == false && Input.is_action_pressed("right") == false && Input.is_action_pressed("up") == false:
																								#get_node("AnimationPlayer").play("nAir")
				pass
			elif Input.is_action_just_pressed("attack") && Input.is_action_pressed("up") || Input.is_action_pressed("c_up"):
																								#get_node("AnimationPlayer").play("upAir")
				pass
			elif Input.is_action_just_pressed("attack") && Input.is_action_pressed("down") || Input.is_action_pressed("c_down"):
																								#get_node("AnimationPlayer").play("dAir")
				pass
			elif Input.is_action_just_pressed("attack") && Input.is_action_pressed("right") || Input.is_action_pressed("c_right"):
				if facingRight == true:
																									#get_node("AnimationPlayer").play("fAir")
					pass
				else:
																									#get_node("AnimationPlayer").play("bAir")
					pass
			elif Input.is_action_just_pressed("attack") && Input.is_action_pressed("left") || Input.is_action_pressed("c_left"):
				if facingRight == true:
																									#get_node("AnimationPlayer").play("bAir")
					pass
				else:
																									#get_node("AnimationPlayer").play("fAir")
					pass
			
			if Input.is_action_pressed("shield"):
																								#get_node("AnimationPlayer").play("airDodge")
				pass
				

func _physics_process(_delta: float) -> void:
	get_input()
	attacks()
	healthbar()

	velocity = move_and_slide(velocity,FLOOR_NORMAL)


#Animation Functions
func canMove():
	allow = true

func cantMove():
	allow = false

func rollRight():
	velocity.x = 2500
	facingRight = true
	isRolling = false

func rollLeft():
	velocity.x = -2500
	facingRight = false
	isRolling  = false

func _crouch():
	isCrouching = true
	get_node("AnimationPlayer").play("Crouching")

func _crouching():
	if Input.is_action_pressed("down"):
		get_node("AnimationPlayer").play("Crouching")
	else:
		get_node("AnimationPlayer").play("unCrouch")

func unCrouch():
	crouch = false
	isCrouching = false

func _shield():
	isShielding = true
	get_node("AnimationPlayer").play("Shielding")


func shielding():
	if Input.is_action_pressed("shield") && isRolling == false:
		get_node("AnimationPlayer").play("Shielding")
		canRoll = true
	else:
		unShield()
		

	if canRoll == true && isRolling == false:
		if Input.is_action_just_pressed("right"):
			get_node("AnimationPlayer").play("rollRight")
			isRolling = true
		elif Input.is_action_just_pressed("left"):
			get_node("AnimationPlayer").play("rollLeft")
		elif Input.is_action_just_pressed("down"):
			isRolling = true
																							#get_node("AnimationPlayer").play("spotDodge")
			pass


func unShield():
	shield = false
	isShielding = false
	canRoll = false
	get_node("AnimationPlayer").play("Idle")
	

func _on_Hitbox_area_entered(area: Area2D) -> void:
	if canTakeDamage == true:
		percent += 10
		if facingRight == true:
			velocity.x = 10 * percent
			velocity.y = 10 * percent
			canTakeDamage = false
		else:
			velocity.x = -10 * percent
			velocity.y = -10 * percent
			canTakeDamage = false
	
func _on_Hitbox_area_exited(area: Area2D) -> void:
	canTakeDamage = true

