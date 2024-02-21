class_name Item
extends Interactible

var player_in = false

var animator

func _ready():
	animator = $AnimatedSprite2D

func interact():
	if (!player_in):
		return
	signal_interact.emit(self)

func _on_body_entered(body):
	if (body is Player):
		player_in = true
		animator.animation = "player_in"

func _on_body_exited(body):
	if (body is Player):
		player_in = false
		animator.animation = "player_out"
