class_name Guide
extends NPC

@export var player_node: Player

var can_interact: bool

func _ready():
	super._ready()
	player = player_node
	enable_interact()

func _physics_process(delta):
	if (!player_node):
		print("Guide has no player to follow!")
		return
	var follow_position = player_node.position
	
	if ((follow_position - position).length() < 30):
		velocity = velocity.move_toward(Vector2(0, 0), 400 * delta)
	else:
		velocity = velocity.move_toward((follow_position - position).normalized() * RUN_SPEED, 400 * delta)
	move_and_slide()

func interact():
	if (!can_interact):
		return
	super.interact()
	disable_interact()

func enable_interact():
	can_interact = true
	animator.animation = "player_in"
	player_node.add_interactible(self)

func disable_interact():
	can_interact = false
	animator.animation = "player_out"
	player_node.remove_interactible(self)
