extends Control



func _on_new_pressed():
	var loading_scene = preload("res://scenes/loading.tscn")
	get_tree().change_scene_to(loading_scene)


func _on_load_pressed():
	var loading_scene = preload("res://scenes/loading.tscn")
	get_tree().change_scene_to(loading_scene)

func _on_options_pressed():
	get_tree().change_scene("res://scenes/test.tscn")


func _on_credits_pressed():
	get_tree().change_scene("res://scenes/test.tscn")


func _on_exit_pressed():
	get_tree().quit()

