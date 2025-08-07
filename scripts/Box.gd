extends KinematicBody2D

var velocity = Vector2.ZERO

func _physics_process(delta):
	var collision = move_and_collide(velocity)
	if velocity:
		velocity = lerp(velocity,Vector2(),0.2)

func apply_movement(vel):
	velocity = vel
