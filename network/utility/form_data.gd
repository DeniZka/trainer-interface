class_name FormData
extends RefCounted

var headers: PackedStringArray
var body: PackedByteArray

static func with_file(endpoint_argument_name: String, file_name: String, file_type: String, file_base64: String) -> FormData:
	const boundary: String = "GodotFileUploadBoundaryZ29kb3RmaWxl"
	var data = FormData.new()
	data.headers = [ "Content-Type: multipart/form-data; boundary=%s" % boundary]
	data.body = _create_form_data_packet(boundary, endpoint_argument_name, file_name, file_type, file_base64)
	return data

static func _create_form_data_packet(boundary: String, endpoint_argument_name: String, file_name: String, file_type: String, file_base64: String) -> PackedByteArray:
	var packet := PackedByteArray()
	var boundary_start = ("\r\n--%s" % boundary).to_utf8_buffer()
	var disposition = ("\r\nContent-Disposition: form-data; name=\"%s\"; filename=\"%s\"" % [endpoint_argument_name, file_name]).to_utf8_buffer()
	var content_type = ("\r\nContent-Type: %s\r\n\r\n" % file_type).to_utf8_buffer()
	var boundary_end = ("\r\n--%s--\r\n" % boundary).to_utf8_buffer()

	packet.append_array(boundary_start)
	packet.append_array(disposition)
	packet.append_array(content_type)
	packet.append_array(Marshalls.base64_to_raw(file_base64))
	packet.append_array(boundary_end)
	return packet
