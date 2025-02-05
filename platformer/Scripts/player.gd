extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const WALL_JUMP_VELOCITY = Vector2(250, -350)
const WALL_SLIDE_GRAVITY = 200.0
const DEATH_Y_THRESHOLD = 800 # Adjust based on your game’s bottom boundary
@onready var map: TileMapLayer = $"../../Level/Map"
@onready var death: Label = $Death

@export var respawn_position: Vector2 = Vector2(0, 0) # Set respawn point

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		if is_on_wall() and velocity.y > 0:
			velocity.y += WALL_SLIDE_GRAVITY * delta
		else:
			velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif is_on_wall():
			var wall_direction = -get_wall_normal().x
			velocity = Vector2(WALL_JUMP_VELOCITY.x * wall_direction, WALL_JUMP_VELOCITY.y)

	# Get movement input
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Check if player fell off screen
	if position.y > DEATH_Y_THRESHOLD:
		die()

	move_and_slide()

func die():
	print("Player died!")  # Debugging message
	position = respawn_position  # Reset position to respawn point
	velocity = Vector2.ZERO  # Stop momentum
