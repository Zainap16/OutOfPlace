extends Node2D
signal game_finished
@export var player_cursor : Node2D

@export var start_speed := 200.0
@export var speed_increase := 15.0

@export var shrink_rate := 0.1
##20% of the original size
@export var minimum_scale := 0.01

@export var screen_margin := 50

var speed := 0.0
var direction := Vector2.ZERO
var score := 0.0
#@onready var countdown_label: Label = $GameStartLabel
@onready var timer: Timer = $Timer
@onready var countdown_label: Label = $GameStartLabel

#@onready var countdown_label: Label = $"../GameStartLabel"
#@onready var timer: Timer = $"../Timer"
@onready var collision: CollisionShape2D = $Circle/CollisionShape2D

#@onready var collision: CollisionShape2D = $CollisionShape2D
var game_started = false
var countdown = 3

func _ready():

	randomize()

	speed = start_speed

	direction = Vector2(
		randf_range(-1,1),
		randf_range(-1,1)
	).normalized()
	


func _process(delta):
	if !game_started:
		return
	score += delta

	move_circle(delta)

	shrink_circle(delta)

	increase_speed(delta)

	check_player()


func move_circle(delta):

	position += direction * speed * delta

	var viewport = get_viewport_rect().size

	if position.x < screen_margin:
		direction.x *= -1

	if position.x > viewport.x - screen_margin:
		direction.x *= -1

	if position.y < screen_margin:
		direction.y *= -1

	if position.y > viewport.y - screen_margin:
		direction.y *= -1


func shrink_circle(delta):

	if scale.x > minimum_scale:

		scale -= Vector2.ONE * shrink_rate * delta

		if scale.x < minimum_scale:
			scale = Vector2.ONE * minimum_scale


func increase_speed(delta):

	speed += speed_increase * delta


func check_player():

	var radius = collision.shape.radius * scale.x

	var distance = global_position.distance_to(player_cursor.global_position)

	if distance > radius:

		game_over()


func game_over():

	print("GAME OVER")
	print("Score: ", snapped(score,0.01))

	get_tree().paused = true
	game_finished.emit()


func _on_timer_timeout() -> void:

	countdown -= 1

	if countdown > 0:
		countdown_label.text = str(countdown)

	elif countdown == 0:
		countdown_label.text = "GO!"

		# Put the circle under the cursor
		global_position = player_cursor.global_position

		game_started = true

	else:
		countdown_label.hide()
		timer.stop()
