extends Control

@export var main_world_scene: PackedScene

func _ready():
	start_cutscene()


func start_cutscene() -> void:

	get_tree().change_scene_to_packed(main_world_scene)
