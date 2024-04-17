extends Marker2D
class_name EnemySpawn

@export var level_scene : Level

@export var timer : Timer

var whale_scene : PackedScene = preload("res://scenes/enemies/whale.tscn")

func _ready() -> void:
	spawn_enemy()

func timer_start() -> void:
	timer.start()

func spawn_enemy() -> void:
	var whale : Whale = whale_scene.instantiate()
	whale.level = level_scene
	whale.position = position
	print("X: " + str(position.x) + ", Y: " + str(position.y))
	whale.connect("dead", timer_start)
	add_child(whale)

func _on_timer_timeout() -> void:
	spawn_enemy()
