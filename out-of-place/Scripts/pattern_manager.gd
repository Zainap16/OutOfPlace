extends Node
class_name PatternManager

signal game_finished
var original_modulates := {}

enum Colors {
	RED,
	GREEN,
	BLUE,
	YELLOW
}

@onready var red: TextureButton = $"../Buttons/Red"
@onready var green: TextureButton = $"../Buttons/Green"
@onready var blue: TextureButton = $"../Buttons/Blue"
@onready var yellow: TextureButton = $"../Buttons/Yellow"


@onready var score_label: Label = $"../CanvasLayer/ScoreLabel"
@onready var status_label: Label = $"../CanvasLayer/StatusLabel"

var pattern = []
var player_pattern = []

var round = 1
var score = 0

var flash_time = 0.6
var waiting_for_player = false

func _ready():
	randomize()

	original_modulates[red] = red.modulate
	original_modulates[green] = green.modulate
	original_modulates[blue] = blue.modulate
	original_modulates[yellow] = yellow.modulate

	start_round()


func start_round():

	waiting_for_player = false
	player_pattern.clear()

	status_label.text = "Watch..."

	pattern.append(randi() % 4)

	score_label.text = "Round %d" % round

	await show_pattern()

	status_label.text = "Your Turn"

	waiting_for_player = true


func show_pattern():

	for colour in pattern:

		await flash(colour)

		await get_tree().create_timer(0.15).timeout


func flash(colour):

	var button : TextureButton

	match colour:
		Colors.RED:
			button = red
		Colors.GREEN:
			button = green
		Colors.BLUE:
			button = blue
		Colors.YELLOW:
			button = yellow

	var tween = create_tween()

	button.modulate = Color(2, 2, 2) # Extra bright
	tween.tween_property(button, "scale", Vector2(1.25, 1.25), 0.08)

	await get_tree().create_timer(flash_time).timeout

	button.modulate = Color.WHITE
	tween = create_tween()
	tween.tween_property(button, "scale", Vector2.ONE, 0.08)


func player_clicked(colour):

	if !waiting_for_player:
		return

	player_pattern.append(colour)

	var current = player_pattern.size()-1

	if player_pattern[current] != pattern[current]:

		game_over()

		return

	if player_pattern.size() == pattern.size():

		round += 1
		score += 1

		flash_time *= 0.95
		flash_time = max(0.15, flash_time)

		await get_tree().create_timer(0.7).timeout

		start_round()


func game_over():

	waiting_for_player = false

	status_label.text = "GAME OVER"

	score_label.text = "Score: %d" % score

	print("Game Over")
	game_finished.emit()
