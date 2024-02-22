class_name Player
extends CharacterBody2D

@export var guide: Guide

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

var animator: AnimatedSprite2D
var direction_facing: String

func _ready():
	grayscale_layer = $GrayscaleShader
	
	dialogue_box = $DialogueBox
	dialogue_name = $DialogueBox/MarginContainer/VBoxContainer/Name
	dialogue_text = $DialogueBox/MarginContainer/VBoxContainer/Dialogue
	
	animator = $AnimatedSprite2D
	direction_facing = "down"

func _physics_process(delta):
	
	handle_input()
	
	if (talking):
		return
	
	# Movement is forbidden while talking
	handle_movement()
	handle_animation()
	
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
		if (holding):
			for i in interactibles:
				if !(i is Item):
					i.interact()
					return
		else:
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
	if (velocity.length() > 0):
		update_interactibles()

func handle_animation():
	if (velocity.length() == 0):
		animator.set_animation("idle_" + direction_facing)
		return
	
	if (velocity.y < -10):
		direction_facing = "up"
	elif (velocity.y > 10):
		direction_facing = "down"
	elif (velocity.x < 0):
		direction_facing = "left"
	elif (velocity.x > 0):
		direction_facing = "right"
	animator.set_animation("walk_" + direction_facing)
	
	if (Input.is_action_pressed("run")):
		animator.speed_scale = 2
	else:
		animator.speed_scale = 1


func add_interactible(interactible):
	if (interactibles.size() == 0):
		interactibles.push_front(interactible)
		update_interactibles()
		return
	
	for i in interactibles.size():
		var interactible_y_pos = interactibles[i].position.y
		var to_be_added_y_pos = interactible.position.y
		
		if (to_be_added_y_pos > interactible_y_pos):
			interactibles.insert(i, interactible)
			update_interactibles()
			return
	
	interactibles.push_back(interactible)
	update_interactibles()

func remove_interactible(interactible):
	interactible.animator.set_animation("player_out")
	interactibles.remove_at(interactibles.find(interactible))
	update_interactibles()

func update_interactibles():
	sort_interactibles()
	var can_interact = true
	for i in interactibles.size():
		var interactible = interactibles[i]
		if (holding && interactible is Item):
			interactible.animator.set_animation("player_out")
		elif (can_interact):
			interactible.animator.set_animation("player_in")
			can_interact = false
		else:
			interactible.animator.set_animation("player_out")

func sort_interactibles():
	if (interactibles.is_empty()):
		return
	interactibles.sort_custom(closer_to_player)

func closer_to_player(a, b) -> bool:
	var a_distance = (a.position - position).length()
	var b_distance = (b.position - position).length()
	
	return a_distance < b_distance

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
	
	animator.speed_scale = 0
	
	var json_string = FileAccess.get_file_as_string("res://assets/dialogue/" + npc_name + ".json")
	var json_object = JSON.parse_string(json_string)
	var conversation = json_object[conversation_name]
	
	dialogue_box.visible = true
	
	talking = true
	current_conversation = conversation
	conversation_position = 0
	show_voiceline()

func end_dialogue():
	animator.speed_scale = 1
	dialogue_box.visible = false
	talking = false

func show_voiceline():
	var text_couple = current_conversation[conversation_position]
	dialogue_name.text = text_couple["Name"]
	dialogue_text.text = text_couple["Text"]

func next_voiceline():
	conversation_position += 1
	if (conversation_position > current_conversation.size() - 1):
		end_dialogue()
	else:
		show_voiceline()




func grayscale_on():
	grayscale_layer.visible = true

func grayscale_off():
	grayscale_layer.visible = false


