extends Area3D
@onready var main_world_scene: Node3D = $".."

@onready var mini_game_holder: Node = $"../MiniGameHolder"
var mini_game_one_piano_tiles = preload("res://Scenes/MiniGameOne/mini_game_one.tscn")
var has_player_entered_piano_tiles: bool = false


func _on_trigger_mini_games_body_entered(body: Node3D) -> void:
	if body.name == "Player" and has_player_entered_piano_tiles == false:
		var piano_tile_game = mini_game_one_piano_tiles.instantiate()
		mini_game_holder.add_child(piano_tile_game)
		main_world_scene.process_mode = Node.PROCESS_MODE_DISABLED
		has_player_entered_piano_tiles = true
	else:
		return


func return_to_main_world():
	
	if Global.piano_tiles_lost == true:
		mini_game_holder.get_child(0).queue_free()
		main_world_scene.process_mode = Node.PROCESS_MODE_INHERIT
	pass
