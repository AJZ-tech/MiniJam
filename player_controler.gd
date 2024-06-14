extends CharacterBody2D

@export var base_speed = 200.0
@export var multiplier = 1.0
@export var deceleration = 10.0

func _physics_process(_delta):
	# Get input vector directly using Input.get_vector
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if input_vector != Vector2.ZERO:
		velocity = input_vector * base_speed * multiplier
	else:
		# Apply deceleration when no input is detected
		if velocity.length() > 0:
			velocity = velocity.move_toward(Vector2.ZERO, deceleration * multiplier)# * _delta)
		
	move_and_slide()
