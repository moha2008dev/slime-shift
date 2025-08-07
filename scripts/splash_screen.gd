extends Control

func _ready():
	$AnimationPlayer.play("splash")
	yield(get_tree().create_timer(3.5),"timeout")
	Global.change_scene("res://scenes/main_menu.tscn")
