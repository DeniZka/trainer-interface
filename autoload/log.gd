extends Node

const LOG_TAG	: String = "[LOG]"
const ERR_TAG	: String = "[ERROR]"
const DEBUG_TAG	: String = "[DEBUG]"

enum Level {
	Trace = 10,
	Debug = 20,
	Info = 30,
	Warn = 40,
	Error = 50,
	Fatal = 60
}

var sensitive: Level = Level.Trace : set = set_sensitive

func set_sensitive(level: Level) -> void:
	sensitive = level
	info("Установлен уровень чувствительности логгирования = %s" % get_sensitive_string(level))

func trace(message: String) -> void:
	write(Level.Trace, message)

func debug(message: String) -> void:
	write(Level.Debug, message)

func info(message: String) -> void:
	write(Level.Info, message)

func warn(message: String) -> void:
	write(Level.Warn, message)

func error(message: String) -> void:
	write(Level.Error, message)

func fatal(message: String) -> void:
	write(Level.Fatal, message)

func write(level: Level, message: String) -> void:
	if level < sensitive:
		return
	
	_write(format_message(get_sensitive_string(level), message))

func _write(message: String) -> void:
	print(message)

func get_sensitive_string(level: int) -> String:
	var index: int = Level.values().find(level)
	return Level.keys()[index] if index > -1 else "Unknown"

func format_message(tag: String, message: String) -> String:
	return "[" + tag.to_upper() + "]\t" + date_time() + ": " + message

func date_time() -> String:
	var time = Time.get_datetime_dict_from_system()
	return "%02d:%02d:%02d-%02d:%02d:%02d" % [time.year, time.month, time.day, time.hour, time.minute, time.second]
