class_name Interactible
extends Node

signal signal_interact(interactible)

func _ready():
	pass

func _process(delta):
	if (Input.is_action_just_pressed("interact")):
		interact()

func interact():
	pass

