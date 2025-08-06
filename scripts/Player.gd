extends KinematicBody2D

export(String,"Normal","Iced","Liquid") var state : String = "Normal"
var x : int = 0
var velocity : Vector2 = Vector2()
var speed : int = 250
var jump : int = -320
var gravity :int = 1200
var height : float = 0
var push_speed : Vector2 = Vector2(300,0)

func _physics_process(_delta) -> void:
	$Label.text = str(int($LiquidTimer.time_left)) if state == "Liquid" else ""
#	$Label.text = state
	_move()
	_jump()
	_switch_states()
	if state == "Iced": _push()
	velocity = move_and_slide(velocity,Vector2.UP,false,4,PI/4,false)

func _move() -> void:
	x = int(Input.get_axis("left","right"))
	velocity.x = lerp(velocity.x,speed * x,0.2)

func _jump() -> void:
	if !is_on_floor():
		velocity.y += gravity * get_physics_process_delta_time()
		if state == "Normal" && Input.is_action_just_pressed("up"):
				if $CoyoteTimer.is_stopped():
					$BufferTimer.start()
				else:
					$CoyoteTimer.stop()
					velocity.y = jump
		height = velocity.y
	else:
		if state == "Iced" && height > 450:
			die()
		velocity.y = 1
		if (Input.is_action_just_pressed("up") || !$BufferTimer.is_stopped()) && state == "Normal":
			$BufferTimer.stop()
			velocity.y = jump
		height = 0

func _push() -> void:
	if get_slide_count() > 0:
		for i in get_slide_count():
			var col = get_slide_collision(i)
			var box = col.collider
			if box.is_in_group("Box"):
				box.apply_movement(-col.normal*0.75)

func _switch_states() -> void:
	if state == "Normal":
		speed = 250
		$LiquidTimer.stop()
	elif state == "Iced":
		speed = 150
		$LiquidTimer.stop()
	elif state == "Liquid":
		speed = 350
		if $LiquidTimer.is_stopped(): $LiquidTimer.start()
		elif $LiquidTimer.time_left < 4:
			$Label.set_deferred("custom_colors/font_color",Color("#d50000"))
		else:
			$Label.set_deferred("custom_colors/font_color",Color("#ffffff"))

func _on_LiquidTimer_timeout() -> void:
	die()

func die() -> void:
	Global.reload_scene()
