extends Control
signal game_finished
#@onready var game_manager = $GameManager
@onready var restart_button = $RestartButton
@onready var game_over_panel = $GameOverPanel
#@onready var game_manager= $PatternManager
@onready var game_manager: PatternManager = $PatternManager


func _ready():
	restart_button.pressed.connect(_on_restart_pressed)
	game_over_panel.hide()

	game_manager.game_finished.connect(_on_game_finished)

func _on_game_finished():
	await get_tree().create_timer(4.0).timeout
	game_finished.emit()

func _on_restart_pressed():
	get_tree().reload_current_scene()
