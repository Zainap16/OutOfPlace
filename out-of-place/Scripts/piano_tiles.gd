extends Node3D # Or Node, depending on your PianoTiles type

@onready var sub_viewport: SubViewport = $SubViewport
@onready var minigame: Node2D = $SubViewport/MiniGameOne


#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("enable_piano_tiles"):
		#start_minigame()

func _ready():
	stop_minigame()

func start_minigame():
	minigame.process_mode = Node.PROCESS_MODE_INHERIT

func stop_minigame():
	minigame.process_mode = Node.PROCESS_MODE_DISABLED
