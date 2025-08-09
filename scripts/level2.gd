extends Node2D

func _ready():
	if Global.auto_save == true :
		_auto_save()

func _auto_save():
	var path = get_tree().current_scene.filename
	var config = ConfigFile.new()
	config.set_value("progress","curent_level" , path)
	config.save("user://save_game.cfg")

