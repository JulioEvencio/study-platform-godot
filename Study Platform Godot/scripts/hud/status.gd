extends Control
class_name Status

@export var hp_bar : TextureProgressBar

func set_hp_max(hp : int) -> void:
	hp_bar.max_value = hp

func set_hp(hp : int) -> void:
	hp_bar.value = hp
