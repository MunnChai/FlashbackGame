class_name Item
extends Area2D

var player
var animator

func _ready():
	animator = $AnimatedSprite2D

func interact():
	if (!player):
		print("Error: interacted with object outside of player collision")
		return
	player.pick_up_item(self)

func _on_body_entered(body):
	if (body is Player):
		player = body
		player.add_interactible(self)
		animator.animation = "player_in"

func _on_body_exited(body):
	if (body is Player):
		player.remove_interactible(self)
		player = null
		animator.animation = "player_out"
