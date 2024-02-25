class_name Item
extends RigidBody2D

@export var sprite_normal: Texture2D
@export var sprite_interactible: Texture2D
@export var item_mass: float

var player
var animator

func _ready():
	animator = $AnimatedSprite2D
	var sprite_frames = SpriteFrames.new()
	animator.sprite_frames = sprite_frames
	sprite_frames.clear_all()
	sprite_frames.add_animation("player_in")
	sprite_frames.add_animation("player_out")
	sprite_frames.add_frame("player_in", sprite_interactible)
	sprite_frames.add_frame("player_out", sprite_normal)
	animator.play("player_out")
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
