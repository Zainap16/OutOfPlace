extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var blob_guy_all_forms_col: Node3D = $"BlobGuy_All_Forms-col"


var targetPosition: Vector3

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if targetPosition != Vector3.ZERO:
		var direction = global_position.direction_to(targetPosition)

		# Ignore vertical movement
		direction.y = 0
		direction = direction.normalized()

		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		look_at(global_position + direction, Vector3.UP)

		if global_position.distance_to(targetPosition) < 1:
			velocity.x = 0
			velocity.z = 0
			targetPosition = Vector3.ZERO

	if Input.is_action_just_pressed("quit"):
			get_tree().quit()
	#_set_animation()
	#
	move_and_slide()

#func _set_animation():
	#if velocity.x:
		#animation_player.play("Running_A")
	#else:
		#animation_player.play("Idle")
