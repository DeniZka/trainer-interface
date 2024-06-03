extends SceneTree

# This scrip using for presetup config variables before start godot building system from command line.
# It change parameters in config.cfg files from command line arguments.
#
# Example usage:
# 	godot -s build_setup.gd ++ --db_ip=127.0.0.1 --db_port=3000
#
# "++" - delimiter for user arguments
# see config.cfg file for check available settings parameters after "++"

func _init() -> void:
	var cmd_args: Dictionary = _cmd_arguments_to_dictionary()
	_update_config_file_from(cmd_args)
	quit()

func _cmd_arguments_to_dictionary() -> Dictionary:
	var args = {}
	for arg in OS.get_cmdline_user_args():
		if arg.find("=") > -1:
			var values = arg.split("=")
			var key = values[0].lstrip("--")
			args[key] = values[1]
	return args

func _update_config_file_from(args: Dictionary) -> void:
	const config_path: String = "res://config.cfg"
	
	var config = ConfigFile.new()
	config.load(config_path)
	
	_update_matching_keys(config, args)
	
	config.save(config_path)

func _update_matching_keys(config: ConfigFile, args: Dictionary) -> void:
	for section in config.get_sections():
		for key in config.get_section_keys(section):
			if args.has(key):
				config.set_value(section, key, args[key])
