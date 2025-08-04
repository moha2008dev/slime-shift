extends Control



func _on_new2_pressed():
	Global.next_scene = "res://scenes/test.tscn"
	var loading_scene = preload("res://scenes/loading.tscn")
	get_tree().change_scene_to(loading_scene)


func _on_load2_pressed():
	Global.next_scene = "res://scenes/test.tscn"
	var loading_scene = preload("res://scenes/loading.tscn")
	get_tree().change_scene_to(loading_scene)

func _on_options2_pressed():
	Global.next_scene = "res://scenes/test.tscn"
	var loading_scene = preload("res://scenes/loading.tscn")
	get_tree().change_scene_to(loading_scene)


func _on_credits2_pressed():
	Global.next_scene = "res://scenes/credits.tscn"
	var loading_scene = preload("res://scenes/loading.tscn")
	get_tree().change_scene_to(loading_scene)


func _on_exit2_pressed():
	get_tree().quit()

