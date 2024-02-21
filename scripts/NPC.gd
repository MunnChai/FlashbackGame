class_name NPC
extends CharacterBody2D

const WALK_SPEED = 75
const RUN_SPEED = 150



func _physics_process(delta):
	
	handle_movement()


func handle_movement():
	move_and_slide()
