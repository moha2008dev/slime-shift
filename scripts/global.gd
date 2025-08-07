extends Control

var cam : Camera2D
var duration : float
var sfx = true 
var vsync = true
var show_fps = false
var auto_save = false
var resolution = 0
var screen = 0 
var fps = 0 

var resolutions : Array = [Vector2(1280, 720),Vector2(1366, 768),
Vector2(1600, 900),Vector2(1920, 1080)]


func _ready():
	if !resolutions.has(OS.get_screen_size()):
		resolutions.append(OS.get_screen_size())
		resolutions.sort()
	resolution = resolutions.size()-1
	load_options()
	yield(get_tree().create_timer(1),"timeout")
	$CanvasLayer/ColorRect.hide()

func change_scene(scene_path:String) -> void:
	$CanvasLayer/ColorRect.show()
	$CanvasLayer/ColorRect/AnimationPlayer.play_backwards("fade_out")
	yield($CanvasLayer/ColorRect/AnimationPlayer,"animation_finished")
	yield(get_tree().create_timer(1),"timeout")
	get_tree().change_scene(scene_path)
	$CanvasLayer/ColorRect/AnimationPlayer.play("fade_out")
	get_tree().paused = false
	yield($CanvasLayer/ColorRect/AnimationPlayer,"animation_finished")
	$CanvasLayer/ColorRect.hide()

func change_scene_to(packed_scene:PackedScene) -> void:
	$CanvasLayer/ColorRect.show()
	$CanvasLayer/ColorRect/AnimationPlayer.play_backwards("fade_out")
	yield($CanvasLayer/ColorRect/AnimationPlayer,"animation_finished")
	yield(get_tree().create_timer(1),"timeout")
	get_tree().change_scene_to(packed_scene)
	$CanvasLayer/ColorRect/AnimationPlayer.play("fade_out")
	yield($CanvasLayer/ColorRect/AnimationPlayer,"animation_finished")
	$CanvasLayer/ColorRect.hide()

func reload_scene() -> void:
	$CanvasLayer/ColorRect.show()
	get_tree().paused = true
	$CanvasLayer/ColorRect/AnimationPlayer.play_backwards("fade_out")
	yield($CanvasLayer/ColorRect/AnimationPlayer,"animation_finished")
	get_tree().reload_current_scene()
	yield(get_tree().create_timer(0.4),"timeout")
	get_tree().paused = false
	$CanvasLayer/ColorRect/AnimationPlayer.play("fade_out")
	yield($CanvasLayer/ColorRect/AnimationPlayer,"animation_finished")
	$CanvasLayer/ColorRect.hide()

func quit() -> void:
	$CanvasLayer/ColorRect.show()
	$CanvasLayer/ColorRect/AnimationPlayer.play_backwards("fade_out")
	yield($CanvasLayer/ColorRect/AnimationPlayer,"animation_finished")
	yield(get_tree().create_timer(1),"timeout")
	get_tree().quit()

func _process(_delta):
	$CanvasLayer/Label.text = str(Engine.get_frames_per_second())
	

func show_fps(x:bool)->void:
	$CanvasLayer/Label.visible = x

func save_options():
	var config = ConfigFile.new()
	config.set_value("sound","sfx",sfx)
	config.set_value("game","vsync",vsync)
	config.set_value("settings","fps",fps)
	config.set_value("game","resolution",resolution)
	config.set_value("game","screen",screen)
	apply_options()
	config.save("user://options.cfg")

func load_options():
	var config = ConfigFile.new()
	var err = config.load("user://options.cfg")
	if err == OK :
		sfx = config.get_value("sound","sfx",sfx)
		vsync = config.get_value("game","vsync",vsync)
		fps = config.get_value("settings","fps",fps)
		resolution = config.get_value("game","resolution",resolution)
		screen = config.get_value("game","screen",screen)
		apply_options()
	else:
		sfx = true
		vsync = true
		auto_save = false
		resolution = resolutions.size()-1
		screen = 0
		fps = 0

func apply_options():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), !sfx)
	match screen:
		0:
			OS.window_fullscreen = true
		1:
			OS.window_fullscreen = false
			OS.window_borderless = true
			OS.window_size = OS.get_screen_size()
			resolution = resolutions.find(OS.get_screen_size())
			OS.window_position = Vector2()
		2:
			OS.window_fullscreen = false
			OS.window_borderless = false
	OS.window_size = resolutions[resolution]
	OS.vsync_enabled = vsync
	OS.window_position = (OS.get_screen_size()-OS.window_size)/2
	match fps:
		0:
			Engine.target_fps = 0
		1:
			Engine.target_fps = 30
		2:
			Engine.target_fps = 60 
		3:
			Engine.target_fps = 144
	Global.show_fps(show_fps)
