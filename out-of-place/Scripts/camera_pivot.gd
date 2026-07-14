extends Node3D

@export var cameraSens = 0.004
@export var cameraSpeed = 0.1

@export var maxZoom = 40
@export var minZoom = 8

@onready var camera_3d: Camera3D = $Camera3D
##pause wasd camera control when false
@export var controls_enabled := true
@export var orbit_sensitivity := 0.005

var orbiting := false

@export var min_pitch := deg_to_rad(-70)
@export var max_pitch := deg_to_rad(-20)

var pitch := 0.0
func _ready() -> void:
	pass

func _input(event):

	if !controls_enabled:
		return

	_camera_zoom()

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			orbiting = event.pressed

	if orbiting and event is InputEventMouseMotion:
		rotation.y -= event.relative.x * orbit_sensitivity

		pitch -= event.relative.y * orbit_sensitivity
		pitch = clamp(pitch, min_pitch, max_pitch)

		camera_3d.rotation.x = pitch
func _camera_zoom():
	var zoomChange = 0
	if Input.is_action_pressed("mouse_wheel_up"):
		zoomChange -= 1
	elif Input.is_action_pressed("mouse_wheel_down"):
		zoomChange += 1
	
	camera_3d.size += zoomChange
	camera_3d.size = clamp(camera_3d.size, minZoom, maxZoom)

func _physics_process(_delta: float) -> void:
	if !controls_enabled:
		return
	_camera_movement()

##WASD to move camera
func _camera_movement():
	var direction = Vector2.ZERO
	direction.y = Input.get_axis("camera_up", "camera_down")
	direction.x = Input.get_axis("camera_left", "camera_right")
	
	global_position += (global_basis * Vector3(direction.x, 0, direction.y)).normalized() * cameraSpeed
