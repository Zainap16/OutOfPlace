extends Node3D
#need to add code so when player presses on player character it wont break and or make it so only floors can be tap-able

@export var excluded: Array[Node3D] = []

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_mouse_click"):
		var player = get_tree().get_first_node_in_group("player")
		player.targetPosition = _get_3d_mouse_position(event.position)
		

func _get_3d_mouse_position(mousePosition2D):
		var camera = get_viewport().get_camera_3d()

		var params = PhysicsRayQueryParameters3D.new()
		params.from = camera.project_ray_origin(mousePosition2D)
		params.to = params.from + camera.project_ray_normal(mousePosition2D) * 1000

		params.exclude = excluded.map(func(obj): return obj.get_rid())

		var result = get_world_3d().direct_space_state.intersect_ray(params)

		if result:
			return result.position

		return Vector3.ZERO
