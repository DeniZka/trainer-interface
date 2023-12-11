class_name SimintechClient
extends Node

signal updated()

func read_signals(database: Dictionary) -> void:
	pass

func build_read_command(signals: Array[String]) -> Dictionary:
	return {
		"cmd": "read_db_signal_arr",
		"sig_name_arr": signals
	}
