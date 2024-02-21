class_name NPC
extends CharacterBody2D

const WALK_SPEED = 75
const RUN_SPEED = 150

@export var npc_name: String
@export var conversations: PackedStringArray
@export var desired_item: Item

var player

var animator

var moving: bool = false
var path: Array
var destination_node: NPCPathfinderNode

func _ready():
	animator = $AnimatedSprite2D

func _physics_process(delta):
	
#	if (Input.is_action_just_pressed("drop_item")):
#		move(Vector2(-30, 60), Vector2(50, 30))
	handle_movement()

func handle_movement():
	if (!moving):
		return
	if (!destination_node):
		return
	
	var destination = destination_node.position
	
	var direction = position.direction_to(destination)
	
	velocity = direction * WALK_SPEED
	
	if ((position - destination).length() < 5):
		if (!path.is_empty()):
			destination_node = path.pop_front()
		else:
			moving = false
			destination_node = null
	
	move_and_slide()

func interact():
	if (!player):
		return
	
	var conv
	if (player.holding):
		if (player.holding == desired_item):
			conv = conversations[0]
		else:
			conv = conversations[1]
	else:
		conv = conversations[randi_range(2, 3)]
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

func move(from_position, to_position):
	path = NPCPathfinder.find_path(from_position, to_position)
	
	print(path)
	destination_node = path.pop_front()
	moving = true
	
	




