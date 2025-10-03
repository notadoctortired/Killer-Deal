extends VideoStreamPlayer

func _ready():
	finished.connect(_load_game)
	
func _load_game():
	get_tree().change_scene_to_file("res://scenes/main_level.tscn")
