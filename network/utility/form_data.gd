## Multipart/form-data is a composite content type 
## most commonly used for sending HTML forms with 
## binary data using the POST method of the HTTP protocol.
## about this format: wikipedia.org/wiki/Multipart/form-data

## In example, after all, result like this:
##
## Content-Type: multipart/form-data; boundary=Asrf456BGe4h
## --Asrf456BGe4h
## Content-Disposition: form-data; name="DestAddress"
##
## Some message #1
## --Asrf456BGe4h
## Content-Disposition: form-data; name="AttachedFile1"; filename="photo.jpg"
## Content-Type: image/jpeg
##
## [base64 for photo.jpg]
## --Asrf456BGe4h--
##

class_name FormData
extends RefCounted

const BOUNDARY: String = "GodotFileUploadBoundaryZ29kb3RmaWxl"

var headers: Array[String]
var content: Array[FormDataItem]

func _init() -> void:
	headers.append("Content-Type: multipart/form-data; boundary=%s" % BOUNDARY)

## Add specific header to multipart form data
func add_header(header: String) -> FormData:
	headers.append(header)
	return self

## Add text to form data body. You can transmit numbers, just use str() for it value
func add_text(field_name: String, value: String) -> FormData:
	var header = "Content-Disposition: form-data; name=\"%s\"" % field_name
	content.append(FormDataItem.new([header], value))
	return self

## Add file to form data body
func add_file(field_name: String, file_name: String, file_type: String, file_base64: String) -> FormData:
	var disposition: String = "Content-Disposition: form-data; name=\"%s\"; filename=\"%s\"" % [field_name, file_name]
	var content_type: String = "Content-Type: %s" % file_type
	content.append(FormDataItem.new([disposition, content_type], file_base64))
	return self

## Convert all body content to string
func body_as_string() -> String:
	var packed_body: PackedStringArray
	var newline: String = "\r\n"
	
	for item in content:
		packed_body.append("--%s" % BOUNDARY)
		packed_body.append(newline)
		for header in item.headers:
			packed_body.append(header)
			packed_body.append(newline)
		packed_body.append(newline)
		packed_body.append(item.content)
		packed_body.append(newline)
	packed_body.append("--%s--" % BOUNDARY)
	packed_body.append(newline)
	
	var newString: String
	for body_line in packed_body:
		newString += body_line
	return newString

## Convert all body content to UTF8 bytes
func body_as_raw() -> PackedByteArray:
	return body_as_string().to_utf8_buffer()

static func with_file(field_name: String, file_name: String, file_type: String, file_base64: String) -> FormData:
	var form_data: FormData = FormData.new()
	form_data.add_file(field_name, file_name, file_type, file_base64)
	return form_data
