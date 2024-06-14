extends Camera2D

enum FollowMode {
	LOCKON,
	SMOOTH,
	BOUND,
	SMOOTH_BOUND
}

@export var target: NodePath
@export var follow_mode: FollowMode = FollowMode.LOCKON
@export var lag_speed: float = 5.0
@export var bounded_border: Vector2 = Vector2(100, 100)

@onready var target_node: Node2D = get_node(target)

func _process(delta):
	if not target_node:
		return

	match follow_mode:
		FollowMode.LOCKON:
			global_position = target_node.global_position
		FollowMode.SMOOTH:
			global_position = global_position.lerp(target_node.global_position, lag_speed * delta)
		FollowMode.BOUND:
			follow_bounded(delta, false)
		FollowMode.SMOOTH_BOUND:
			follow_bounded(delta, true)

func follow_bounded(delta, smooth):
	var screen_size = get_viewport_rect().size
	var half_screen_size = (screen_size / zoom) / 2

	var target_pos_in_camera = target_node.global_position - global_position

	var new_position = global_position

	if target_pos_in_camera.x < - half_screen_size.x + bounded_border.x:
		new_position.x = target_node.global_position.x + half_screen_size.x - bounded_border.x
	elif target_pos_in_camera.x > half_screen_size.x - bounded_border.x:
		new_position.x = target_node.global_position.x - half_screen_size.x + bounded_border.x

	if target_pos_in_camera.y < - half_screen_size.y + bounded_border.y:
		new_position.y = target_node.global_position.y + half_screen_size.y - bounded_border.y
	elif target_pos_in_camera.y > half_screen_size.y - bounded_border.y:
		new_position.y = target_node.global_position.y - half_screen_size.y + bounded_border.y

	if smooth:
		global_position = global_position.lerp(new_position, lag_speed * delta)
	else:
		global_position = new_position
