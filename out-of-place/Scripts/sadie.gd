extends Node3D

@export var intro_to_sadie: DialogicTimeline
@export var player_hands_tiisue_to_sadie: DialogicTimeline
@export var sadie_advises_player_of_nate: DialogicTimeline
var player_in_range := false
@onready var interact_label: Label3D = $InteractLabel
var dialogue_stage := 0


func _ready() -> void:
	interact_label.visible = false
	if !Dialogic.timeline_ended.is_connected(_dialogue_finished):
		Dialogic.timeline_ended.connect(_dialogue_finished)

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

	if !Global.met_sadie:
		Global.met_sadie = true
		Dialogic.start(intro_to_sadie)
	elif Global.has_tissue:
		Dialogic.start(player_hands_tiisue_to_sadie)
		Global.has_tissue = false
	elif Global.nate_first_convo:
		Dialogic.start(sadie_advises_player_of_nate)
	#Dialogic.timeline_ended.connect(_dialogue_finished, CONNECT_ONE_SHOT)
func _on_dialogue_finished():
	var player = get_tree().get_first_node_in_group("player")

	if player:
		player.movement_enabled = true
