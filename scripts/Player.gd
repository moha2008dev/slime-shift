extends KinematicBody2D

var state = "Normal"
var x = 0
var states = [["Normal",250],["Iced",150],["Liquid",350]]
var velocity = Vector2()
var speed = 250
var jump = -320
var gravity = 1200
var push_speed = Vector2(300,0)

func _physics_process(_delta):
	$Label.text = state
	_move()
	_jump()
	_switch_states()
	if state == "Iced": _push()
	velocity = move_and_slide(velocity,Vector2.UP,false,4,PI/4,false)

func _move():
	x = Input.get_axis("left","right")
	velocity.x = lerp(velocity.x,speed * x,0.2)

func _jump():
	if !is_on_floor():
		velocity.y += gravity * get_physics_process_delta_time()
		if state == "Normal" && Input.is_action_just_pressed("up"):
				if $CoyoteTimer.is_stopped():
					$BufferTimer.start()
				else:
					$CoyoteTimer.stop()
					velocity.y = jump
	else:
		velocity.y = 1
		if (Input.is_action_just_pressed("up") || !$BufferTimer.is_stopped()) && state == "Normal":
			$BufferTimer.stop()
			velocity.y = jump

func _push():
	if get_slide_count() > 0:
		for i in get_slide_count():
			var col = get_slide_collision(i)
			var box = col.collider
			if box.is_in_group("Box"):
				box.apply_movement(-col.normal*0.75)

func _switch_states():
	if Input.is_action_just_pressed("switch"):
		var index = states.find([state,speed])
		index = 0 if index == states.size()-1 else index + 1
		state = states[index][0]
		speed = states[index][1]
