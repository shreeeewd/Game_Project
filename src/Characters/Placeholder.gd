extends Variables


func _physics_process(_delta: float) -> void:
	var jump_counter: int
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y > 0
	var direction: = get_direction(calculate_jump(jump_counter))
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	move_and_slide(_velocity, FLOOR_NORMAL)

func calculate_jump(jump_counter) -> int:
	if onGround == true:
		jump_counter = 2
	else:
		if onGround == false and Input.is_action_just_pressed("jump"):
			jump_counter = jump_counter - 2
	return jump_counter

func get_direction(jump_counter: int) -> Vector2:
	return  Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and jump_counter > 0 else 1.0
	)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var out: = linear_velocity
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	if is_jump_interrupted:
		out.y = 0.0
	return out
	
	
