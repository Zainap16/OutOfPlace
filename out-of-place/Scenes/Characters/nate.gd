extends Node3D

@export var intro_to_nate: DialogicTimeline
@export var play_hands_lamp_to_nate: DialogicTimeline

@export var final_choice_end: DialogicTimeline

var player_in_range := false
@onready var interact_label: Label3D = $InteractLabel
@onready var form_5: MeshInstance3D = $"../../Player/BlobGuy_All_Forms-col/Form5"
@onready var form_4: MeshInstance3D = $"../../Player/BlobGuy_All_Forms-col/Form4"
var waiting_for_second_dialogue := false

@export var GameEndChoice: PackedScene

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

#func _dialogue_finished():
	#var player = get_tree().get_first_node_in_group("player")
	#player.movement_enabled = true

func interact():
	var player = get_tree().get_first_node_in_group("player")
	player.movement_enabled = false

	if !Global.nate_first_convo:
		Global.nate_first_convo = true
		Dialogic.start(intro_to_nate)
	elif Global.player_has_lamp:
		form_5.visible = true
		form_4.visible = false
		Global.player_has_lamp = false
		waiting_for_second_dialogue = true
		
		Dialogic.start(play_hands_lamp_to_nate)

func _on_dialogue_finished():
	var player = get_tree().get_first_node_in_group("player")

	if player:
		player.movement_enabled = true

func _dialogue_finished():
	# Was the lamp dialogue just finished?
	if waiting_for_second_dialogue:
		waiting_for_second_dialogue = false
		Dialogic.start(final_choice_end)
		return

	# Final dialogue finished, give control back
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.movement_enabled = true
	open_game_end_choice()


func open_game_end_choice():
#	change scenes
	get_tree().change_scene_to_packed(GameEndChoice)
#	have scene open in main world
	#var scene = GameEndChoice.instantiate()
	#get_tree().current_scene.add_child(scene)
