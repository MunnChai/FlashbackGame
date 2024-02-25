extends Node2D

var NPCs

# Called when the node enters the scene tree for the first time.
func _ready():
	NPCs = get_children()
	print(NPCs)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func progress_dialogue(npc_name):
	var npc = NPCs[NPCs.find(npc_name)]
	if (npc.current_conversation + 1 > npc.conversations.size() - 1):
		print(npc_name, "'s dialogue cannot progress any further!")
		return
	
	npc.current_conversation += 1
