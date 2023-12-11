class_name WriteSignalsSimintechCommand
extends SimintechCommand

var signal_names: Array
var signal_values: Array

func _init() -> void:
	type = "write_db_signal_arr"

func serialize() -> Dictionary:
	var base: Dictionary = super.serialize()
	base["sig_name_arr"] = signal_names
	base["sig_val_arr"] = signal_values
	return base
