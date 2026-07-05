extends Node3D

@export var cameraSens = 0.004
@export var cameraSpeed = 0.1

@export var maxZoom = 40
@export var minZoom = 8

@onready var camera_3d: Camera3D = $Camera3D

func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func _input(_event):
#below does the camera invisble
	#if event is InputEventMouseMotion:
		#rotation.y -= event.relative.x * cameraSens
	_camera_zoom()
##use mouse wheel to zoom in or out
func _camera_zoom():
	var zoomChange = 0
	if Input.is_action_pressed("mouse_wheel_up"):
		zoomChange -= 1
	elif Input.is_action_pressed("mouse_wheel_down"):
		zoomChange += 1
	
	camera_3d.size += zoomChange
	camera_3d.size = clamp(camera_3d.size, minZoom, maxZoom)

func _physics_process(_delta: float) -> void:
	_camera_movement()

##WASD to move camera
func _camera_movement():
	var direction = Vector2.ZERO
	direction.y = Input.get_axis("camera_up", "camera_down")
	direction.x = Input.get_axis("camera_left", "camera_right")
	
	global_position += (global_basis * Vector3(direction.x, 0, direction.y)).normalized() * cameraSpeed
