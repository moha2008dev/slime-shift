extends Control

func _on_new2_pressed():
	delet_save()
	Global.next_scene = "res://scenes/World.tscn"
	var loading_scene = preload("res://scenes/loading.tscn")
	Global.change_scene_to(loading_scene)

func delet_save():
	var file = Directory.new()
	if file.file_exists("user://save_game.cfg"):
		file.remove("user://save_game.cfg")
		
func load_level():
	var config = ConfigFile.new()
	var err = config.load("user://save_game.cfg")
	if err == OK:
		var path = config.get_value("progress","curent_level" ,null)
		return path
	else:
		return null 
	

func _on_load2_pressed():
	var level = load_level()
	if level!= null:
		Global.next_scene = level
		var loading_scene = preload("res://scenes/loading.tscn")
		Global.change_scene_to(loading_scene)

func _on_options2_pressed():
	Global.change_scene("res://scenes/options.tscn")


func _on_credits2_pressed():
	Global.change_scene("res://scenes/credits.tscn")


func _on_exit2_pressed():
	Global.quit()

