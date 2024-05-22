extends Control

const config_file_name: String = "config.json"

func _ready() -> void:
	print(OS.get_environment("PATH"))
