class_name ReadSignalsSimintechCommand
extends SimintechCommand

var signals: Array[String]

func _init() -> void:
	type = "read_db_signal_arr"

func serialize() -> Dictionary:
	var base: Dictionary = super.serialize()
	base["sig_name_arr"] = signals
	return base
