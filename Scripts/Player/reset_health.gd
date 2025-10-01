extends Control

func _ready():
	_save_to_file("","res://data/health.txt")
	
func _save_to_file(content,file_dir):
	var file = FileAccess.open(file_dir, FileAccess.WRITE)
	file.store_string(content)
	
func _load_from_file(file_dir):
	var file = FileAccess.open("res://scripts/reactions/current_flask.txt", FileAccess.READ)
	var content = file.get_as_text()
	return content
