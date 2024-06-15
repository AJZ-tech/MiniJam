extends Area2D

@export var speed = 500.0
var velocity = Vector2.ZERO

func _process(_delta):
	position += velocity * _delta

	# Optionally, add code to destroy the bullet when it goes out of bounds
	if position.x < -100 or position.x > get_viewport_rect().size.x + 100 or position.y < -100 or position.y > get_viewport_rect().size.y + 100:
		queue_free()
