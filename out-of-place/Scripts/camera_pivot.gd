extends Node3D

@export var camera_speed := 0.1
@export var orbit_sensitivity := 0.005

@export var max_zoom := 40.0
@export var min_zoom := 8.0

@export var controls_enabled := true

@export var min_pitch := deg_to_rad(-70)
@export var max_pitch := deg_to_rad(-20)

@onready var camera_3d: Camera3D = $Camera3D

var orbiting := false
var pitch := 0.0


func _ready() -> void:
	# Match the stored pitch to whatever the camera is set to in the editor.
	pitch = camera_3d.rotation.x


func _input(event: InputEvent) -> void:
	if !controls_enabled:
		return

	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_MIDDLE:
				orbiting = event.pressed

			MOUSE_BUTTON_WHEEL_UP:
				if event.pressed:
					camera_3d.size = max(min_zoom, camera_3d.size - 1)

			MOUSE_BUTTON_WHEEL_DOWN:
				if event.pressed:
					camera_3d.size = min(max_zoom, camera_3d.size + 1)

	if orbiting and event is InputEventMouseMotion:
		# Rotate the pivot left/right
		rotation.y -= event.relative.x * orbit_sensitivity

		# Rotate the camera up/down
		pitch -= event.relative.y * orbit_sensitivity
		pitch = clamp(pitch, min_pitch, max_pitch)

		camera_3d.rotation.x = pitch


func _physics_process(delta: float) -> void:
	if !controls_enabled:
		return

	_camera_movement(delta)


func _camera_movement(delta: float) -> void:
	var direction := Vector2(
		Input.get_axis("camera_left", "camera_right"),
		Input.get_axis("camera_up", "camera_down")
	)

	if direction == Vector2.ZERO:
		return

	var movement := (global_basis * Vector3(direction.x, 0, direction.y)).normalized()

	global_position += movement * camera_speed * delta * 60.0
