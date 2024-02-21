class_name NPC
extends CharacterBody2D

const WALK_SPEED = 75
const RUN_SPEED = 150

@export var npc_name: String
@export var conversations: PackedStringArray

var player

var animator

func _physics_process(delta):
	
	handle_movement()

func handle_movement():
	move_and_slide()

func _ready():
	animator = $AnimatedSprite2D

func interact():
	if (!player):
		return
	var conv = conversations[randi_range(0, 1)]
	player.start_dialogue(npc_name, conv)

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
