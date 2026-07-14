extends Node3D

@onready var mini_game_holder: CanvasLayer = $MiniGameHolder
@onready var black_screen_canvas_layer: CanvasLayer = $BlackScreenCanvasLayer

@onready var camera_pivot: Node3D = $MainWorldScene/cameraPivot

@export var excluded: Array[Node3D] = []

var mini_game_one_piano_tiles = preload("res://Scenes/MiniGameOne/mini_game_one.tscn")
var mini_game_circle = preload("res://Scenes/MiniGameTwo/stay_in_the_circle.tscn")
var mini_game_memory_game = preload("res://Scenes/MiniGameThree/memory_game.tscn")

var has_player_entered_piano_tiles := false
var has_player_entered_circle := false
var has_player_entered_memory_game := false

var current_minigame: Node = null
var playing_minigame := false
var current_game_index := 0

func _ready() -> void:
	#var player = get_tree().get_first_node_in_group("player")
	pass
#	values below needs to be turned on so the mini games can commence
	#player.movement_enabled = false

	#camera_pivot.controls_enabled = false

	#call_deferred("start_piano_tiles")

func _input(event: InputEvent) -> void:
	if playing_minigame:
		return

	if event.is_action_pressed("left_mouse_click"):
		var player = get_tree().get_first_node_in_group("player")
		player.targetPosition = _get_3d_mouse_position(event.position)


func _get_3d_mouse_position(mouse_position_2d):
	var camera = get_viewport().get_camera_3d()

	var params = PhysicsRayQueryParameters3D.new()
	params.from = camera.project_ray_origin(mouse_position_2d)
	params.to = params.from + camera.project_ray_normal(mouse_position_2d) * 1000

	params.exclude = excluded.map(func(obj): return obj.get_rid())

	var result = get_world_3d().direct_space_state.intersect_ray(params)

	if result:
		return result.position

	return Vector3.ZERO


func _on_trigger_mini_games_body_entered(body: Node3D) -> void:
	if body.name != "Player":
		return

	if has_player_entered_piano_tiles:
		return

	call_deferred("start_piano_tiles")


func start_piano_tiles():

	has_player_entered_piano_tiles = true
	playing_minigame = true

	current_minigame = mini_game_one_piano_tiles.instantiate()
	mini_game_holder.add_child(current_minigame)

	current_minigame.game_finished.connect(close_current_minigame)

	var player = get_tree().get_first_node_in_group("player")
	player.movement_enabled = false
	player.targetPosition = Vector3.ZERO

	camera_pivot.controls_enabled = false
func finish_intro():

	var player = get_tree().get_first_node_in_group("player")
	player.movement_enabled = true
	player.targetPosition = Vector3.ZERO

	camera_pivot.controls_enabled = true

	playing_minigame = false
	await get_tree().create_timer(4.0).timeout
	black_screen_canvas_layer.hide()

func close_current_minigame():

	get_tree().paused = false

	if current_minigame:
		current_minigame.queue_free()
		current_minigame = null
# Wait 4 seconds before the next game
	
	current_game_index += 1

	match current_game_index:
		1:
			start_circle_game()
		2:
			start_memory_game()
		_:
			finish_intro()

func start_circle_game():

	has_player_entered_circle = true
	playing_minigame = true

	current_minigame = mini_game_circle.instantiate()
	mini_game_holder.add_child(current_minigame)

	current_minigame.game_finished.connect(close_current_minigame)

	var player = get_tree().get_first_node_in_group("player")
	player.movement_enabled = false
	player.targetPosition = Vector3.ZERO

	camera_pivot.controls_enabled = false

func start_memory_game():

	has_player_entered_memory_game = true
	playing_minigame = true

	current_minigame = mini_game_memory_game.instantiate()
	mini_game_holder.add_child(current_minigame)

	#current_minigame.game_finished.connect(close_current_minigame)
	current_minigame.get_node("PatternManager").game_finished.connect(close_current_minigame)

	var player = get_tree().get_first_node_in_group("player")
	player.movement_enabled = false
	player.targetPosition = Vector3.ZERO

	camera_pivot.controls_enabled = false



#func _on_circle_area_body_entered(body: Node3D) -> void:
	#if body.name != "Player":
		#return
#
	#if has_player_entered_circle:
		#return
#
	#call_deferred("start_circle_game")
#
#
#func _on_memory_game_area_body_entered(body: Node3D) -> void:
	#if body.name != "Player":
		#return
#
	#if has_player_entered_memory_game:
		#return
#
	#call_deferred("start_memory_game")
