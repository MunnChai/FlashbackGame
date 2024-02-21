class_name NPCPathfinder
extends Node2D

var nodes: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	nodes = get_children()

func find_path(from, to):
	pass
