extends Node

@export var hp_label : Label
@export var player : Player

func _ready() -> void:
	update_hp()

func _process(_delta : float) -> void:
	update_hp()

func update_hp() -> void:
	hp_label.text = "HP: " + str(player.hp_current) + "/" + "" + str(player.hp_max)
