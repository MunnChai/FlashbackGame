class_name Door
extends Area2D

var player
@export var destination: Vector2 = Vector2(0, 0)

var animator

# Called when the node enters the scene tree for the first time.
func _ready():
	animator = $AnimatedSprite2D # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact():
	if (!player):
		return
	teleport()

func _on_body_entered(body):
	if (body is Player):
		player = body
		player.add_interactible(self)
		
func _on_body_exited(body):
	if (body is Player):
		player.remove_interactible(self)
		player = null

# requires player!
func teleport():
	player.position = destination
	player.guide.position = destination
