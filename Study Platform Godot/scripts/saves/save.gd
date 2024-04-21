extends Node

const save_path : String = "user://save_game.dat"

var save_data : Dictionary = {
	"player_position": Vector2(0, 0),
	"player_cure_position": 0
}

func save_game() -> void:
	var file : FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	
	if file != null:
		file.store_var(save_data)
		file.close()

func load_game() -> void:
	if FileAccess.file_exists(save_path):
		var file : FileAccess = FileAccess.open(save_path, FileAccess.READ)
		
		if file != null:
			save_data = file.get_var()
			file.close()
