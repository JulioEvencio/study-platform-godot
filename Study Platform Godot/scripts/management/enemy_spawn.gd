extends Marker2D
class_name EnemySpawn

@export var level_scene : Level

@export var timer : Timer

var whale_scene : PackedScene = preload("res://scenes/enemies/whale.tscn")

var enemy_amount : int = 0
var can_spawn : bool = true

func _ready() -> void:
	spawn_enemy()

func timer_start() -> void:
	enemy_amount -= 1
	timer.start()

func spawn_enemy() -> void:
	if enemy_amount < 1:
		var whale : Whale = whale_scene.instantiate()
		whale.level = level_scene
		whale.position = position
		whale.connect("dead", timer_start)
		level_scene.add_entities(whale)
		enemy_amount += 1

func _on_timer_timeout() -> void:
	if can_spawn:
		spawn_enemy()

func _on_area_2d_body_entered(_body : Player) -> void:
	can_spawn = false

func _on_area_2d_body_exited(_body : Player) -> void:
	can_spawn = true
	timer.start()
