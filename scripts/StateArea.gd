extends Area2D

export(String,"Normal","Iced","Liquid") var state : String = "Normal"

func _ready():
	$AnimatedSprite2.play(state)

func _on_StateArea_body_entered(body : Node2D):
	if body.is_in_group("Player"):
		if body.state == state: return
		body.tp(global_position + Vector2(0,-20))
		yield(get_tree().create_timer(1),"timeout")
		$"../Player/AnimationPlayer".play("transform")
		yield(get_tree().create_timer(0.1),"timeout")
		body.state = state


func _on_killArea_body_entered(body):
	if body.is_in_group("Player"):
		$"../Player".die()
