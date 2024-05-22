extends Node

const config_file_name: String = "config.cfg"

var configs: Dictionary

func _ready() -> void:
	var config = ConfigFile.new()
	config.load("res://%s" % config_file_name)
	for section in config.get_sections():
		print("section: %s" % section)
		for key in config.get_section_keys(section):
			print("%s = %s" % [key, config.get_value(section, key)])

func get_db_url() -> String:
	return "192.168.100.105:8000"

func get_backend_url() -> String:
	return "192.168.100.151:10508"

func get_backend_ip() -> String:
	return "192.168.100.151"

func get_backend_port() -> int:
	return 10508

func get_amqp_url() -> String:
	return "192.168.100.157:61613"

func get_amqp_username() -> String:
	return "admin"

func get_amqp_password() -> String:
	return "105admin105"

func _load_configs() -> void:
	var path: String = "res://%s" % config_file_name
	
	if FileAccess.file_exists(path):
		_update_config_from_json(FileAccess.get_file_as_string(path))

func _update_config_from_json(json_string: String) -> void:
	var json = JSON.new()
	var error = json.parse(json_string)
