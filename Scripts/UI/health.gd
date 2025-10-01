extends ProgressBar

func _ready():
	value_changed.connect(_save_to_file)

func _save_to_file(content,file_dir):
	print("updated")
	content = str(value)
	file_dir = "res://data/health.txt"
	var file = FileAccess.open(file_dir, FileAccess.WRITE)
	file.store_string(content)
