class_name ArrayUtils
extends RefCounted

static func from_array_to_string(array: Array) -> String:
	var line: String
	for element in array:
		line += "%s, " % element
	return line
