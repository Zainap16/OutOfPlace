extends Node3D

@onready var sprite: Sprite3D = $Sprite3D
@onready var anxiety_meter: ProgressBar = $AnxietyMeter
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var damage_bar: ProgressBar = $AnxietyMeter/DamageBar

func _ready():
	anxiety_meter.init_anxiety_meter(100)
	Dialogic.signal_event.connect(_on_dialogic_signal)
#
func _input(event):
	if event.is_action_pressed("ui_accept"):
		if anxiety_meter.value <= 0:
			return
		else:
			anxiety_meter.take_damage(10)

func _on_dialogic_signal(argument: String):
	if argument == "anxiety_fail":
		animation_player.play("rapid_anxiety")

		await animation_player.animation_finished

		
