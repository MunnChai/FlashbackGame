class_name Guide
extends NPC

@export var player_node: Player

var can_interact: bool
var direction_facing: String = "down"
 
func _ready():
	animator = $AnimatedSprite2D
	current_conversation = 0
	animator.speed_scale = 2

func _physics_process(delta):
	if (!player_node):
		print("Guide has no player to follow!")
		return
	
	# So time "freezes" while talking
	if (player_node.talking):
		return
	handle_animation()
	handle_moving(delta)

func handle_moving(delta):
	var follow_position = player_node.position
	
	if ((follow_position - position).length() < 25):
		velocity = velocity.move_toward(Vector2(0, 0), 500 * delta)
	elif ((follow_position - position).length() > 40):
		velocity = velocity.move_toward((follow_position - position).normalized() * RUN_SPEED * 1.5, 750 * delta)
	else:
		velocity = velocity.move_toward((follow_position - position).normalized() * RUN_SPEED, 750 * delta)
	move_and_slide()

func handle_animation():
	if (velocity.length() == 0):
		animator.set_animation("idle_" + direction_facing)
		return
	
	if (velocity.y < -10):
		direction_facing = "up"
	elif (velocity.y > 10):
		direction_facing = "down"
	elif (velocity.x < -10):
		direction_facing = "left"
	elif (velocity.x > 10):
		direction_facing = "right"
	animator.set_animation("walk_" + direction_facing) 

func interact():
	if (!can_interact):
		return
	super.interact()
	disable_interact()

func enable_interact():
	can_interact = true
	player_node.add_interactible(self)

func disable_interact():
	can_interact = false
	player_node.remove_interactible(self)
