class_name FormData
extends RefCounted

const BOUNDARY: String = "GodotFileUploadBoundaryZ29kb3RmaWxl"

var headers: Array[String]
var content: Array[FormDataItem]

func _init() -> void:
	headers.append("Content-Type: multipart/form-data; boundary=%s" % BOUNDARY)

func add_header(header: String) -> FormData:
	headers.append(header)
	return self

func add_text(field_name: String, value: String) -> FormData:
	var header = "Content-Disposition: form-data; name=\"%s\"" % field_name
	content.append(FormDataItem.new([header], value))
	return self

func add_file(field_name: String, file_name: String, file_type: String, file_base64: String) -> FormData:
	var disposition: String = "Content-Disposition: form-data; name=\"%s\"; filename=\"%s\"" % [field_name, file_name]
	var content_type: String = "Content-Type: %s" % file_type
	content.append(FormDataItem.new([disposition, content_type], file_base64))
	return self

func body_as_string() -> String:
	var result: PackedStringArray
	var newline: String = "\r\n"
	
	for item in content:
		result.append("--%s" % BOUNDARY)
		result.append(newline)
		for header in item.headers:
			result.append(header)
			result.append(newline)
		result.append(newline)
		result.append(item.content)
		result.append(newline)
	result.append("--%s--" % BOUNDARY)
	result.append(newline)
	
	var newString: String
	for line in result:
		newString += line
	return newString

func body_as_raw() -> PackedByteArray:
	return body_as_string().to_utf8_buffer()

static func with_file(field_name: String, file_name: String, file_type: String, file_base64: String) -> FormData:
	var form_data: FormData = FormData.new()
	form_data.add_file(field_name, file_name, file_type, file_base64)
	return form_data
