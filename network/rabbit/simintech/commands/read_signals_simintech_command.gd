class_name ReadSignalsSimintechCommand
extends SimintechCommand

const type_name: String = "read_db_signal_arr"

var signals: Array[String]

func _init() -> void:
	type = type_name

func serialize() -> Dictionary:
	var base: Dictionary = super.serialize()
	base["sig_name_arr"] = signals
	return base
