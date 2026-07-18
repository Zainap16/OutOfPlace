extends Node3D

@onready var box_empty: MeshInstance3D = $BoxEmpty
@onready var box_empty_001: MeshInstance3D = $BoxEmpty_001
@onready var box_empty_002: MeshInstance3D = $BoxEmpty_002
@onready var bobs_blanket: MeshInstance3D = $BobsBlanket

var player_in_area = false
var player_in_area_blanket = false
@onready var drop_area: Area3D = $DropArea
@onready var blanket_trigger: Area3D = $BlanketTrigger
@onready var camera_pivot: Node3D = $"../../cameraPivot"
var boxes_dropped := 0

@onready var tissue_game_area: Area3D = $Tornado/TissueGameArea

@export var tissue_game_scene: PackedScene
@export var mini_game_holder :CanvasLayer
var started := false

var current_game: Node
var player_in_lamp_area:= false

@export var memory_game_scene: PackedScene

var current_memory_game: Node
var memory_game_started := false

@onready var nate_memory_game: Area3D = $NateMemoryGame
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	box_empty.visible = false
	box_empty_001.visible = false
	box_empty_002.visible = false
	

func _process(_delta):
	if player_in_area and Input.is_action_just_pressed("interact"):

		var player = get_tree().get_first_node_in_group("player")

		if player.carrying_box:

			player.set_box_visual(false)

			if boxes_dropped == 0:
				box_empty.visible = true
			elif boxes_dropped == 1:
				box_empty_001.visible = true
			elif boxes_dropped == 2:
				box_empty_002.visible = true
				Global.stacked_all_boxes = true
				

			boxes_dropped += 1

			if boxes_dropped >= 3:
				drop_area.monitoring = false
	if player_in_area_blanket and Input.is_action_just_pressed("interact"):
		Global.has_blanket = true
		bobs_blanket.visible = false
		print("collected bobs blanket")
		blanket_trigger.monitoring = false
	if player_in_lamp_area and Input.is_action_just_pressed("interact"):
		nates_night_light.visible = false
		Global.player_has_lamp = true
		print("Player collected Nate's Night Light")
		
	else:
		return


func _on_drop_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_area = true


func _on_drop_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_area = false


func _on_blanket_trigger_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_area_blanket = true


func _on_blanket_trigger_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_area_blanket = false


func _on_tissue_game_area_body_entered(body: Node3D) -> void:

	if !body.is_in_group("player"):
		return

	if started:
		return

	if !Global.tissue_game_unlocked:
		return

	started = true

	# Disable player controls
	body.movement_enabled = false
	body.targetPosition = Vector3.ZERO
	camera_pivot.controls_enabled = false

	current_game = tissue_game_scene.instantiate()
	mini_game_holder.add_child(current_game)

	current_game.game_finished.connect(_on_game_finished)

	
func _on_game_finished():

	Global.has_tissue = true
	Global.tissue_game_unlocked = false

	if current_game:
		current_game.queue_free()
		current_game = null

	var player = get_tree().get_first_node_in_group("player")
	player.movement_enabled = true
	player.targetPosition = Vector3.ZERO

	camera_pivot.controls_enabled = true

	tissue_game_area.monitoring = false


func _on_nate_memory_game_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("Player entered memory game")
	if !body.is_in_group("player"):
		return

	if memory_game_started:
		return

	if !Global.memory_game_unlocked:
		return

	memory_game_started = true

	body.movement_enabled = false
	body.targetPosition = Vector3.ZERO
	camera_pivot.controls_enabled = false

	current_memory_game = memory_game_scene.instantiate()
	mini_game_holder.add_child(current_memory_game)

	current_memory_game.game_finished.connect(_on_memory_game_finished)
@onready var cave_rock_door: MeshInstance3D = $NateMemoryGame/CaveRockDoor

func _on_memory_game_finished():

	Global.memory_game_unlocked = false
	Global.memory_game_completed = true

	if current_memory_game:
		current_memory_game.queue_free()
		cave_rock_door.queue_free()
		current_memory_game = null

	var player = get_tree().get_first_node_in_group("player")
	player.movement_enabled = true
	player.targetPosition = Vector3.ZERO

	camera_pivot.controls_enabled = true

	nate_memory_game.monitoring = false

@onready var nates_night_light: MeshInstance3D = $NateMemoryGame/NatesNightLight

func _on_nates_night_light_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_lamp_area = true


func _on_nate_memory_game_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_lamp_area = false
