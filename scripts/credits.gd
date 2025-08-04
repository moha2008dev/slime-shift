extends Control

var previos_scene = "res://scenes/main_menu.tscn"

func _ready():
	$credits_up.play("up")


func _on_credits_up_animation_finished(anim_name):
	if anim_name == "up":
		Global.next_scene = "res://scenes/main_menu.tscn"
		get_tree().change_scene("res://scenes/loading.tscn")


func _on_exitb_pressed():
	Global.next_scene = "res://scenes/main_menu.tscn"
	get_tree().change_scene("res://scenes/loading.tscn")
