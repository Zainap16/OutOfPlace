extends Node3D

@onready var sprite: Sprite3D = $Sprite3D
@onready var anxiety_meter: ProgressBar = $AnxietyMeter

func _ready():
	anxiety_meter.init_anxiety_meter(100)
#
func _input(event):
	if event.is_action_pressed("ui_accept"):
		if anxiety_meter.value <= 0:
			return
		else:
			anxiety_meter.take_damage(10)
