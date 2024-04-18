extends Node
class_name Level

@export var player : Player

@export var cure_potion_amount : Label

@export var status_scene : Status

func _ready() -> void:
	update_hp()

func _process(_delta : float) -> void:
	cure_potion_amount.text = "x" + str(player.cure_potion_amount)
	update_hp()

func add_entities(entity : CharacterBody2D) -> void:
	call_deferred("add_child", entity)

func add_item(item : RigidBody2D) -> void:
	add_child(item)
	var impulse_x : float = 50 if randi_range(0, 10) % 2 == 0 else -50
	var impulse_y : float = -50
	item.apply_impulse(Vector2(impulse_x, impulse_y))

func update_hp() -> void:
	status_scene.set_hp_max(player.hp_max)
	status_scene.set_hp(player.hp_current)
