extends ProgressBar

@onready var timer: Timer = $Timer
@onready var damage_bar: ProgressBar = $DamageBar

var anxiety_meter = 0 : set = _set_anxiety_meter


func take_damage(amount: float):
	anxiety_meter -= amount


func heal(amount: float):
	anxiety_meter += amount


func _set_anxiety_meter(new_anxiety_meter):
	var pre_anxiety_meter = anxiety_meter

	anxiety_meter = clamp(new_anxiety_meter, 0, max_value)
	value = anxiety_meter

	if anxiety_meter <= 0:
		anxiety_meter = 0
		return

	if anxiety_meter < pre_anxiety_meter:
		timer.start()
	else:
		damage_bar.value = anxiety_meter


func init_anxiety_meter(_anxiety_meter):
	anxiety_meter = _anxiety_meter
	max_value = anxiety_meter
	value = anxiety_meter

	damage_bar.max_value = anxiety_meter
	damage_bar.value = anxiety_meter


func _on_timer_timeout():
	damage_bar.value = anxiety_meter
