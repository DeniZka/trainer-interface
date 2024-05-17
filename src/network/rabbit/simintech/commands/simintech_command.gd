class_name SimintechCommand
extends RefCounted

var type: String

func serialize() -> Dictionary:
	return {
		"cmd": type
	}
