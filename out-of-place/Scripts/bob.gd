extends Node3D

@export var intro_bob_timeline: DialogicTimeline
@export var bob_apologizes_to_player: DialogicTimeline
@export var bob_advises_playr_of_sadie: DialogicTimeline
var player_in_range := false
@onready var interact_label: Label3D = $InteractLabel
@onready var form_3: MeshInstance3D = $"../../Player/BlobGuy_All_Forms-col/Form3"
@onready var form_2: MeshInstance3D = $"../../Player/BlobGuy_All_Forms-col/Form2"

var unlock_tissue_game := false
var start_game_after_dialogue := false
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

	if unlock_tissue_game:
		unlock_tissue_game = false
		Global.tissue_game_unlocked = true

func interact():
	var player = get_tree().get_first_node_in_group("player")
	player.movement_enabled = false

	if !Global.get_insulted_by_bob:
		Dialogic.start(intro_bob_timeline)
		Global.get_insulted_by_bob = true
	elif Global.bob_apologized_to_player && Global.has_blanket:
		Dialogic.start(bob_apologizes_to_player)
		Global.bob_apologized_to_player = false
		form_3.visible = true
		form_2.visible = false
	elif Global.first_convo_with_sadie:
		unlock_tissue_game = true
		Dialogic.start(bob_advises_playr_of_sadie)
		
	Dialogic.timeline_ended.connect(_dialogue_finished, CONNECT_ONE_SHOT)

func _on_dialogue_finished():
	var player = get_tree().get_first_node_in_group("player")

	if player:
		player.movement_enabled = true
