extends Area2D

export(String,"Normal","Iced","Liquid") var state : String = "Normal"

func _on_StateArea_body_entered(body : Node2D):
	if body.is_in_group("Player"):
		body.state = state
	$"../stateArea/AnimatedSprite2".play(state)
