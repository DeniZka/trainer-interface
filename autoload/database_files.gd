extends Node

func save(tag: String, file_base64: String) -> void:
	var file = FileAccess.open("res://files/%s.base64" % tag, FileAccess.WRITE)
	file.store_line(file_base64)
	file.close()

func load_file(tag: String) -> String:
	var file = FileAccess.open("res://files/%s.base64" % tag, FileAccess.READ)
	var base64 = file.get_as_text()
	file.close()
	return base64
