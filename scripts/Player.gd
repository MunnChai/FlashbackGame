class_name Player
extends CharacterBody2D

const WALK_SPEED = 75
const RUN_SPEED = 150

var holding: Item
var interactibles: Array

var grayscale_layer

# For all things dialogue related
var dialogue_box
var dialogue_name
var dialogue_text

var talking: bool
var current_conversation: Array
var conversation_position: int

func _ready():
	grayscale_layer = $GrayscaleShader
	
	dialogue_box = $DialogueBox
	dialogue_name = $DialogueBox/MarginContainer/VBoxContainer/Name
	dialogue_text = $DialogueBox/MarginContainer/VBoxContainer/Dialogue

func _physics_process(delta):
	
	handle_input()
	
	if (talking):
		return
	
	# Movement is forbidden while talking
	handle_movement()
	
	if (holding):
		holding.position = global_position + Vector2(0, -13)

func handle_input():
	
	if (talking && Input.is_action_just_pressed("interact")):
		next_voiceline()
		return
	
	if (talking):
		return
	# Below are all actions forbidden while talking
	if (Input.is_action_just_pressed("drop_item") && holding):
		drop_item()
	
	if (interactibles.size() > 0 && Input.is_action_just_pressed("interact")):
		print(interactibles)
		interactibles[0].interact()

func handle_movement():
	var x_direction = Input.get_axis("left", "right")
	if x_direction:
		velocity.x = x_direction * WALK_SPEED
	else:
		velocity.x = 0
	
	var y_direction = Input.get_axis("up", "down")
	if y_direction:
		velocity.y = y_direction * WALK_SPEED
	else:
		velocity.y = 0
	
	if (x_direction && y_direction):
		velocity /= sqrt(2)
	
	if (Input.is_action_pressed("run")):
		velocity *= 2
	
	move_and_slide()

func add_interactible(interactible):
	if (interactibles.size() == 0):
		interactibles.push_front(interactible)
		return
	
	for i in interactibles.size():
		var interactible_y_pos = interactibles[i].position.y
		var to_be_added_y_pos = interactible.position.y
		
		if (to_be_added_y_pos > interactible_y_pos):
			interactibles.insert(i, interactible)
			return
	
	interactibles.push_back(interactible)

func remove_interactible(interactible):
	interactibles.remove_at(interactibles.find(interactible))

func pick_up_item(item):
	if (talking || holding):
		return
	remove_interactible(item)
	holding = item

func drop_item():
	holding.position = global_position + Vector2(0, 8)
	holding = null

func start_dialogue(npc_name, conversation_name):
	if (talking):
		return
	
	var json_string = FileAccess.get_file_as_string("res://assets/dialogue/test_dialogue.json")
	var json_object = JSON.parse_string(json_string)
	var conversation = json_object[conversation_name]
	
	dialogue_box.visible = true
	
	talking = true
	current_conversation = conversation
	conversation_position = 0
	show_voiceline(conversation_position)

func end_dialogue():
	dialogue_box.visible = false
	talking = false

func show_voiceline(position):
	var text_couple = current_conversation[conversation_position]
	dialogue_name.text = text_couple["Name"]
	dialogue_text.text = text_couple["Text"]

func next_voiceline():
	conversation_position += 1
	if (conversation_position > current_conversation.size() - 1):
		end_dialogue()
	else:
		show_voiceline(conversation_position)

func grayscale_on():
	grayscale_layer.visible = true

func grayscale_off():
	grayscale_layer.visible = false


