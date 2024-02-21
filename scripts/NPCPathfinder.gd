class_name NPCPathfinder
extends Node2D

static var nodes: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	nodes = get_children()

# Returns path of nodes from given node to destination node, including start and end nodes
static func find_path(from_position, to_position) -> Array:
	
	var from_node = get_node_at(from_position)
	var to_node = get_node_at(to_position)
	if (from_node == null):
		print("No node found at from_position:", from_position)
		return []
	if (to_node == null):
		print("No node found at to_position:", from_position)
		return []
	if (from_node == to_node):
		return [from_node]
	
	var visited = [from_node]
	var to_traverse = [from_node]
	var paths = [[from_node]]
	var current_node
	var current_path
	
	while (!to_traverse.is_empty()):
		current_node = to_traverse.pop_front()
		current_path = paths.pop_front()
		
		visited.push_back(current_node)
		
		for node in current_node.connected_nodes:
			if (node == to_node):
				current_path.push_back(node)
				return current_path
			if (node not in visited):
				to_traverse.push_front(node)
				current_path.push_back(node)
				paths.push_front(current_path.duplicate())
				current_path.pop_back()
	
	print("No path found from ", from_position, " to ", to_position)
	return []

static func get_node_at(node_position) -> NPCPathfinderNode:
	for node in nodes:
		if (node.position == node_position):
			return node
	
	return null
