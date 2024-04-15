extends Node
class_name Level

@export var hp_label : Label
@export var player : Player

@export var cure_potion_amount : Label

func _ready() -> void:
	update_hp()

func _process(_delta : float) -> void:
	cure_potion_amount.text = "x" + str(player.cure_potion_amount)
	update_hp()

func add_item(item : RigidBody2D) -> void:
	add_child(item)
	var impulse_x : float = 50 if randi_range(0, 10) % 2 == 0 else -50
	var impulse_y : float = -50
	item.apply_impulse(Vector2(impulse_x, impulse_y))

func update_hp() -> void:
	hp_label.text = "HP: " + str(player.hp_current) + "/" + "" + str(player.hp_max)
