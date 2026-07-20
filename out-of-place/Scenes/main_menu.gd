extends Control

@export var StartGame: PackedScene
@onready var instructions: Sprite2D = $Instructions
@onready var continue_button: Button = $Instructions/ContinueButton

func _ready() -> void:
	instructions.visible = false
	continue_button.visible = false

func _on_start_button_pressed() -> void:
#	play OOPOpeningCutScene
#after video is finished, change to main scene
	get_tree().change_scene_to_packed(StartGame)


func _on_controls_button_pressed() -> void:
#	instructions on how to play
	instructions.visible = true
	continue_button.visible = true
	


func _on_continue_button_pressed() -> void:
	instructions.visible = false
	continue_button.visible = false
