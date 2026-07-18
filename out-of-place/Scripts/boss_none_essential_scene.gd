extends Node3D
@onready var player_cam: Camera3D = $CameraManager/PlayerCam
@onready var boss_cam: Camera3D = $CameraManager/BossCam
@onready var both_cam: Camera3D = $CameraManager/BothCam
@onready var boss_label_dialogue: Label3D = $BossLabelDialogue
@onready var player_dialogue: Label3D = $PlayerDialogue
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var boss_dialogue = ["For these hanouse actions i sentence you..", " be exiled and being stripped of your title as a citizen", "There is no place for you here", "You are worth nothing here so with the garbage you belong"]

@export var main_world_scene: PackedScene

func _ready():
	start_cutscene()


func start_cutscene() -> void:
	# Start on boss camera
	switch_camera(boss_cam)

	# Show each boss dialogue
	for line in boss_dialogue:
		boss_label_dialogue.text = line
		await get_tree().create_timer(3.0).timeout

	# Switch to player camera
	switch_camera(player_cam)


	await get_tree().create_timer(3.0).timeout


	switch_camera(both_cam)
	player_dialogue.text = ""
	boss_label_dialogue.text = ""
	animation_player.play("cam")
	await animation_player.animation_finished

	get_tree().change_scene_to_packed(main_world_scene)
	
	#get_tree().quit()
	
func switch_camera(cam: Camera3D) -> void:
	player_cam.current = false
	boss_cam.current = false
	both_cam.current = false

	cam.current = true
