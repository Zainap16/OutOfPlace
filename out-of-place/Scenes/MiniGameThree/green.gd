extends TextureButton
@export var colour_id : int

@onready var game_manager: Node = $"../../PatternManager"

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():

	if game_manager == null:
		return

	game_manager.player_clicked(colour_id)
