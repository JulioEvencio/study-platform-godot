extends Label
class_name FloatText

func set_config(new_text : String, color : Color, vector2 : Vector2):
	set_text(new_text)
	modulate = color
	position = vector2

func _on_timer_timeout() -> void:
	queue_free()
