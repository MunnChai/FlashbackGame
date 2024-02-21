class_name NPCPathfinderNode
extends Node2D

@export var node1: NPCPathfinderNode
@export var node2: NPCPathfinderNode
@export var node3: NPCPathfinderNode

var connected_nodes: Array

func _ready():
	if (node1):
		connected_nodes.append(node1)
	if (node2):
		connected_nodes.append(node2)
	if (node3):
		connected_nodes.append(node3)
