extends KinematicBody2D

export(String,"Normal","Iced","Liquid") var state : String = "Normal"
var x : int = 0
var can_climb : bool = false
var climbing : bool = false
var velocity : Vector2 = Vector2()
var speed : int = 250
var jump : int = -320
var gravity :int = 1200
var height : float = 0

func _ready() -> void:
	$AnimatedSprite2D.play(state)
	match $AnimatedSprite2D.animation:
		"Normal":
			$AnimatedSprite2D.material.set("shader_param/color",Color(0.15,0.9,1))
		"Iced":
			$AnimatedSprite2D.material.set("shader_param/color",Color(0.27,0.27,1))
		"Liquid":
			$AnimatedSprite2D.material.set("shader_param/color",Color(1,0.3,0.3))
			
func _unhandled_input(event):
	if  event.is_action_pressed("save"):
		save_game(get_tree().current_scene.filename)
		
		
func save_game(level_path) :
	var config = ConfigFile.new()
	config.set_value("progress","curent_level" , level_path)
	config.save("user://save_game.cfg")


func _physics_process(_delta) -> void:
	$AnimatedSprite2D.play(state)
	if $CPUParticles2D.emitting:
		return
	$Label.text = str(int($LiquidTimer.time_left)) if state == $AnimatedSprite2D.animation\
	&& state == "Liquid" && !$AnimatedSprite2D/AnimationPlayer.is_playing() else ""
	if !$AnimatedSprite2D/AnimationPlayer.is_playing():_move()
	else:velocity.x = 0
	_jump()
	_switch_states()
	pause()
	if state == "Iced": _push()
	velocity = move_and_slide(velocity,Vector2.UP)

func _move() -> void:
	x = int(Input.get_axis("left","right"))
	velocity.x = lerp(velocity.x,speed * x,0.2) if !climbing else lerp(velocity.x,speed/3.0 * x,0.2)
	if x>0:
		$AnimatedSprite2D.flip_h = false
	elif x < 0 :
		$AnimatedSprite2D.flip_h = true

func _jump() -> void:
	if climbing:
		velocity.y = int(Input.get_axis("up","down")) * 100
		return
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
			$CPUParticles2D.emitting = true
			$AnimatedSprite2D.hide()
			Global.cam.shake(0.5,1)
			yield(get_tree().create_timer(1),"timeout")
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
		can_climb = true
	elif state == "Iced":
		speed = 150
		can_climb = false
		$LiquidTimer.stop()
	elif state == "Liquid":
		speed = 350
		if $LiquidTimer.is_stopped() && !$AnimatedSprite2D/AnimationPlayer.is_playing(): $LiquidTimer.start() and $AnimatedSprite2D.play("Liquid")
		elif $LiquidTimer.time_left < 4:
			$Label.set_deferred("custom_colors/font_color",Color("#d50000"))
		else:
			$Label.set_deferred("custom_colors/font_color",Color("#ffffff"))
		can_climb = false

func _play(anim:String) -> void:
	$AnimatedSprite2D.play(anim)

func _on_LiquidTimer_timeout() -> void:
	die()

func die() -> void:
	Global.reload_scene()

func tp(pos:Vector2) -> void:
	$AnimatedSprite2D.stop()
	$LiquidTimer.stop()
	$AnimatedSprite2D/AnimationPlayer.play("anim")
	yield($AnimatedSprite2D/AnimationPlayer,"animation_finished")
	global_position = pos
	yield(get_tree(),"idle_frame")
	match $AnimatedSprite2D.animation:
		"Normal":
			$AnimatedSprite2D.material.set("shader_param/color",Color(0.15,0.9,1))
		"Iced":
			$AnimatedSprite2D.material.set("shader_param/color",Color(0.27,0.27,1))
		"Liquid":
			$AnimatedSprite2D.material.set("shader_param/color",Color(1,0.3,0.3))
	$AnimatedSprite2D/AnimationPlayer.play_backwards("anim")

func pause() -> void:
	if Input.is_action_pressed("ui_cancel"):
		get_parent().add_child(preload("res://scenes/PauseMenu.tscn").instance())
