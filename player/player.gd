extends KinematicBody2D

# Laws of Physics
const GRAVITY = Vector2(0, 1000)

# Movement Constants
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_FRICTION = 20
const MOVEMENT_SPEED = 400
const ACCELERATION = 0.8
const JUMP_FORCE = 400
const JUMP_TIME_THRESHOLD = 0.2 # seconds

# Player Variables
var velocity = Vector2()
var can_jump = false
var jump_timer = 0


# Start
func _ready():
	set_fixed_process(true)

# Processing
func _fixed_process(delta):
	# Add Gravity
	velocity += GRAVITY * delta
	
	# Increment time
	jump_timer += delta
	
	# Old:
	# move(velocity)
	
	# New:
	# Move and Slide
	velocity = move_and_slide(velocity, FLOOR_NORMAL, SLOPE_FRICTION)
	
	# Jump Timer Controller
	if(is_move_and_slide_on_floor()):
		jump_timer = 0
	
	# Can jump?
	can_jump = jump_timer < JUMP_TIME_THRESHOLD
	
	# Movement
	var movement = 0
	
	# Input: LEFT
	if(Input.is_action_pressed("ui_left")):
		movement -= 1
	
	# Input: RIGHT
	if(Input.is_action_pressed("ui_right")):
		movement += 1
	
	# Set movement speed
	movement *= MOVEMENT_SPEED
	
	# Change horizontal velocity
	velocity.x = lerp(velocity.x, movement, ACCELERATION)
	
	# Input: Jump
	if(can_jump && Input.is_action_pressed("ui_up")):
		velocity.y -= JUMP_FORCE
		jump_timer = JUMP_TIME_THRESHOLD
