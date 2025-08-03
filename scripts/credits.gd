extends Control

var previos_scene = "res://scenes/main_menu.tscn"

func _ready():
	$credits_up.play("up")


func _on_credits_up_animation_finished(anim_name):
	if anim_name == "up":
		get_tree().change_scene(previos_scene)


func _on_exitb_pressed():
	get_tree().change_scene(previos_scene)
