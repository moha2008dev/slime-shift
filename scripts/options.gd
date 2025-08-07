extends Control


func _ready():
	$Panel/sfx.pressed = Global.sfx
	$"Panel/v-sync".pressed = Global.vsync
	$"Panel/Show FPS".pressed = Global.show_fps
	$Panel/resolution.clear()
	for i in range(Global.resolutions.size()):
		var res = Global.resolutions[i]
		$Panel/resolution.add_item("%d x %d" % [res.x, res.y])
	for i in range(Global.resolutions.size()):
		if Global.resolutions[i] == OS.window_size:
			$Panel/resolution.select(i)
			break
	$Panel/screen.clear()
	$Panel/screen.add_item("fullscreen")
	$Panel/screen.add_item("windowed fullscreen")
	$Panel/screen.add_item("windowed")
	$Panel/fps.clear()
	$Panel/fps.add_item("unlimited")
	$Panel/fps.add_item("30")
	$Panel/fps.add_item("60")
	$Panel/fps.add_item("144")
	$Panel/screen.select(Global.screen)
	$Panel/resolution.select(Global.resolution)
	$Panel/fps.select(Global.fps)

func _process(delta):
	$Panel/resolution.select(Global.resolution)

func _on_exit_pressed():
	Global.change_scene("res://scenes/main_menu.tscn")


func _on_sfx_toggled(button_pressed):
	Global.sfx = button_pressed
	Global.save_options()

func _on_vsync_toggled(button_pressed):
	Global.vsync = button_pressed
	Global.save_options()

func _on_Show_FPS_toggled(button_pressed):
	Global.show_fps = button_pressed
	Global.save_options()

func _on_AutoSave_toggled(button_pressed):
	Global.auto_save = button_pressed
	Global.save_options()

func _on_resolution_item_selected(index):
	Global.resolution = index
	Global.save_options()

func _on_screen_item_selected(index):
	Global.screen = index
	Global.save_options()

func _on_fps_item_selected(index):
	Global.fps = index
	Global.save_options()

func _on_reset_pressed():
	var file = Directory.new()
	if file.file_exists("user://options.cfg"):
		file.remove("user://options.cfg")
	Global.load_options()
	Global.save_options()
	get_tree().reload_current_scene()
