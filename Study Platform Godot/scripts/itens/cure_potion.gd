extends RigidBody2D

@onready var animation_player : AnimationPlayer = get_node("AnimationPlayer")

func self_free() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	animation_player.play("free")
