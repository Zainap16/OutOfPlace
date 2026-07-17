extends Node3D
#signal box_changed(carrying)


#forms
@onready var normal : MeshInstance3D = $"../Player/BlobGuy_All_Forms-col/Form1"
@onready var holding: MeshInstance3D = $"../Player/PlayerHoldingBoxes/Form2HoldingBoxEmpty"
#boxes
@onready var box_empty: MeshInstance3D = $BoxEmpty
@onready var box_empty_001: MeshInstance3D = $BoxEmpty_001
@onready var box_empty_002: MeshInstance3D = $BoxEmpty_002
@onready var box_trigger: Area3D = $BoxTrigger

var player_in_area = false
var carrying_box := false

var boxes_picked_up := 0

func _process(_delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("interact"):

		var player = get_tree().get_first_node_in_group("player")

		if !player.carrying_box:

			player.set_box_visual(true)

			if boxes_picked_up == 0:
				box_empty.queue_free()
			elif boxes_picked_up == 1:
				box_empty_001.queue_free()
			elif boxes_picked_up == 2:
				box_empty_002.queue_free()

			boxes_picked_up += 1

			if boxes_picked_up >= 3:
				box_trigger.monitoring = false


func _on_box_trigger_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_area = true
		
func _on_box_trigger_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_area = false
