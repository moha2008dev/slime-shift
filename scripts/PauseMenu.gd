extends CanvasLayer

func _ready():
	get_tree().paused = true

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = false
		queue_free()

func _on_resume_pressed():
	get_tree().paused = false
	queue_free()

func _on_restart_pressed():
	Global.reload_scene()

func _on_exit_pressed():
	Global.change_scene("res://scenes/main_menu.tscn")
