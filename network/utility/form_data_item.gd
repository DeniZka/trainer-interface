class_name FormDataItem
extends RefCounted

var headers: Array[String]
var content: String

func _init(headers: Array[String], content: String) -> void:
	self.headers = headers
	self.content = content
