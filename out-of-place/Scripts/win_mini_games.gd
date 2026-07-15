extends Node3D

var has_player_entered_circle:= false

func _on_circle_area_body_entered(body: Node3D) -> void:
	if body.name != "Player":
		return

	if has_player_entered_circle:
		print("DONT win circle game")
		return

	call_deferred("start_circle_game")
	
func start_circle_game():
	print("Start win circle game")
	has_player_entered_circle = true


func _on_box_trigger_body_exited(body: Node3D) -> void:
	pass # Replace with function body.
