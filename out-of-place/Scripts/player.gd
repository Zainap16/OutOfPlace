extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var blob_guy_all_forms_col: Node3D = $"BlobGuy_All_Forms-col"
@export var movement_enabled := true
@export var jump_velocity := 6.0
@export var gravity := 9.8
var targetPosition: Vector3

var current_npc: Node = null



var carrying_box := false
@onready var holding: MeshInstance3D = $"BlobGuy_All_Forms-col/Form5"
@onready var normal: MeshInstance3D = $"BlobGuy_All_Forms-col/Form1"

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and current_npc:
		targetPosition = Vector3.ZERO
		velocity.x = 0
		velocity.z = 0
		current_npc.interact()
	if !movement_enabled:
		velocity = Vector3.ZERO
		move_and_slide()
		return
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
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
func set_current_npc(npc):
	current_npc = npc

func clear_current_npc(npc):
	if current_npc == npc:
		current_npc = null
		
func set_box_visual(has_box: bool):
	carrying_box = has_box

	normal.visible = !has_box
	holding.visible = has_box

#func _set_animation():
	#if velocity.x:
		#animation_player.play("Running_A")
	#else:
		#animation_player.play("Idle")
