extends Control

var previos_scene = "res://scenes/main_menu.tscn"

func _on_credits_up_animation_finished(anim_name):
	if anim_name == "up":
		Global.change_scene(previos_scene)


func _on_exitb_pressed():
	Global.change_scene(previos_scene)
