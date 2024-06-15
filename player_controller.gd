extends CharacterBody2D

@export var base_speed = 200.0
@export var multiplier = 1.0
@export var deceleration = 10.0
@export var bullet_scene: PackedScene = preload("res://Shooter/Bullet.tscn")

var shoot_cooldown = 0.2
var shoot_timer = 0.0

func _ready():
	print("Player ready...")
	if bullet_scene:
		print("Bullet scene preloaded successfully")

func _physics_process(delta):
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if input_vector != Vector2.ZERO:
		velocity = input_vector * base_speed * multiplier
	else:
		if velocity.length() > 0:
			velocity = velocity.move_toward(Vector2.ZERO, deceleration * multiplier)

	move_and_slide()

	var mouse_position = get_global_mouse_position()
	look_at(mouse_position)

	shoot_timer -= delta
	if Input.is_action_pressed("shoot") and shoot_timer <= 0:
		print("Shoot action detected")
		shoot(mouse_position)
		shoot_timer = shoot_cooldown

func shoot(target_position):
	if not bullet_scene:
		print("Bullet scene not preloaded!")
		return

	print("Shooting bullet...")  # Debug print
	var bullet = bullet_scene.instantiate()
	bullet.position = global_position
	bullet.look_at(target_position)
	get_parent().add_child(bullet)
	if bullet.has_method("set_velocity"):
		print("Bullet script found.")  # Debug print
		bullet.velocity = (target_position - global_position).normalized() * bullet.speed
	else:
		print("Bullet script not found!")  # Debug print
	print("Bullet instantiated")  # Debug print
