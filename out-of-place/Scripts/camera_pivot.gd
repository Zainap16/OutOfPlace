extends Node3D

#bob_speed = 6–10 for slower or faster movement.
#bob_amount = 0.03–0.10 for a subtle or stronger effect.

#need to add smooth transitions when moving

@export var bob_speed := 8.0
@export var bob_amount := 0.08

var time := 0.0
var original_position: Vector3

func _ready():
	original_position = position

func _process(delta):
	var player = get_parent()

	# Only bob when moving horizontally
	var moving = Vector2(player.velocity.x, player.velocity.z).length() > 0.1

	if moving:
		time += delta * bob_speed
		position.y = original_position.y + sin(time) * bob_amount
	else:
		time = 0.0
		position.y = lerp(position.y, original_position.y, delta * 10)
