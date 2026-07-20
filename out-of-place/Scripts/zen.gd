extends Node3D

@export var intro_zeb_timeline: DialogicTimeline
@export var zen_advises_about_bob: DialogicTimeline
var player_in_range := false
@onready var interact_label: Label3D = $InteractLabel
var dialogue_stage := 0

@onready var form_1: MeshInstance3D = $"../../Player/BlobGuy_All_Forms-col/Form1"
@onready var form_2: MeshInstance3D = $"../../Player/BlobGuy_All_Forms-col/Form2"

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
		Dialogic.start(intro_zeb_timeline)
		form_2.visible = true
		form_1.visible = false
	if Global.get_insulted_by_bob:
		dialogue_stage = 1
		Dialogic.start(zen_advises_about_bob)
		print("zen_advises_about_bob: "+ str(zen_advises_about_bob))
	Dialogic.timeline_ended.connect(_dialogue_finished, CONNECT_ONE_SHOT)

#
func _on_dialogue_finished():
	var player = get_tree().get_first_node_in_group("player")

	if player:
		player.movement_enabled = true
