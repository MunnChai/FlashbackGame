class_name Item
extends RigidBody2D

@export var item_mass: float

var player
var animator

func _ready():
	animator = $AnimatedSprite2D
	lock_rotation = true
	mass = item_mass

func interact():
	if (!player):
		print("Error: interacted with item outside of player collision")
		return
	player.pick_up_item(self)

func _on_body_entered(body):
	if (body is Player):
		player = body
		player.add_interactible(self)

func _on_body_exited(body):
	if (body is Player):
		player.remove_interactible(self)
		player = null
