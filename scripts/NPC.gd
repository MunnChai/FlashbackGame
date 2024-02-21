class_name NPC
extends CharacterBody2D

const WALK_SPEED = 75
const RUN_SPEED = 150

signal signal_interact(interactible)

var player_in

var animator

func _physics_process(delta):
	
	handle_movement()


func handle_movement():
	move_and_slide()


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
