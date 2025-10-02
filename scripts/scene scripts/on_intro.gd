extends Control

func _ready():
	_save_to_file("","res://data/health.txt")
	_save_to_file("","res://data/lives.txt")
	_save_to_file("","res://data/kills.txt")
	
func _save_to_file(content,file_dir):
	var file = FileAccess.open(file_dir, FileAccess.WRITE)
	file.store_string(content)
