extends Node3D

@export var intro_bob_timeline: DialogicTimeline
@export var bob_apologizes_to_player: DialogicTimeline
var player_in_range := false
@onready var interact_label: Label3D = $InteractLabel
var dialogue_stage := 0


func _ready() -> void:
	interact_label.visible = false

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		body.set_current_npc(self)
		interact_label.visible = true


func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		body.clear_current_npc(self)
		interact_label.visible = false

func _dialogue_finished():
	var player = get_tree().get_first_node_in_group("player")
	player.movement_enabled = true

func interact():
	var player = get_tree().get_first_node_in_group("player")
	player.movement_enabled = false

	if dialogue_stage == 0:
		Dialogic.start(intro_bob_timeline)
	if Global.bob_apologized_to_player:
		dialogue_stage = 1
		Dialogic.start(bob_apologizes_to_player)
		print("bob_apologizes_to_player: "+ str(bob_apologizes_to_player))
	Dialogic.timeline_ended.connect(_dialogue_finished, CONNECT_ONE_SHOT)

func _on_dialogue_finished():
	var player = get_tree().get_first_node_in_group("player")

	if player:
		player.movement_enabled = true
