extends ParallaxBackground

@export var can_process_parallax : bool
@export var layers_speed : Array[int]

func _ready() -> void:
	set_physics_process(can_process_parallax)

func _physics_process(delta : float):
	for index in get_child_count():
		if get_child(index) is ParallaxLayer:
			get_child(index).motion_offset.x -= layers_speed[index] * delta
