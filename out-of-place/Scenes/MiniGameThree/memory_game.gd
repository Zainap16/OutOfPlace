extends Control

#@onready var game_manager = $GameManager
@onready var restart_button = $RestartButton
@onready var game_over_panel = $GameOverPanel
@onready var game_manager: Node = $PatternManager


func _ready():

	restart_button.pressed.connect(_on_restart_pressed)

	game_over_panel.hide()


func _on_restart_pressed():

	get_tree().reload_current_scene()
