extends Node2D

var state = ""
var is_pressed = false

func _ready():
	$AnimatedSprite.play(state)
	$Label.text = str($AnimatedSprite.playing)
	
func _process(delta):
	$AnimatedSprite.play(state)
	$Label.text = str($AnimatedSprite.playing)



func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") and !is_pressed:
		is_pressed = true 
		state = "pressed"

func _on_Area2D_body_exited(body):
	if body.is_in_group("Player") and is_pressed:
		is_pressed = true
		state = "pressed"
	elif body.is_in_group("Player") and !is_pressed:
		is_pressed = false
		state = "normal"
