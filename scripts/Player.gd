class_name Player
extends CharacterBody2D

const WALK_SPEED = 75
const RUN_SPEED = 150

var holding: Item

func _physics_process(delta):
	
	handle_input()
	handle_movement()
	
	if (holding):
		holding.position = global_position + Vector2(0, -12)

func handle_input():
	if (Input.is_action_just_pressed("drop_item") && holding):
		drop_item()

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

func pick_up_item(item):
	holding = item

func drop_item():
	holding.position = global_position + Vector2(0, 8)
	holding = null
