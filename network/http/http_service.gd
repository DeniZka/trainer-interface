class_name HTTPService
extends RefCounted

var http: HTTPRequest

func _init(http: HTTPRequest) -> void:
	self.http = http

func send_get(url: String, headers: PackedStringArray = []) -> HTTPResponse:
	return await send(url, HTTPClient.METHOD_GET)

func send_patch(url: String, headers: PackedStringArray = []) -> HTTPResponse:
	return await send(url, HTTPClient.METHOD_PATCH)

func send_delete(url: String, headers: PackedStringArray = []) -> HTTPResponse:
	return await send(url, HTTPClient.METHOD_DELETE)

func send_put(url: String) -> HTTPResponse:
	return await send(url, HTTPClient.METHOD_PUT)

func send_post(url: String) -> HTTPResponse:
	return await send(url, HTTPClient.METHOD_POST)

func send(url: String, method: HTTPClient.Method, headers: PackedStringArray = []) -> HTTPResponse:
	var error = http.request(url, headers, method)
	if error != OK:
		push_error("Invalid request to %s" % url)
		return HTTPResponse.error()
	
	var response = await http.request_completed
	return HTTPResponse.valid(response[0], response[1], response[2], _body_from(response))

func download_file(url: String) -> HTTPResponse:
	var error = http.request(url, [], HTTPClient.METHOD_GET)
	if error != OK:
		push_error("Invalid downaload try, %s" % url)
		return HTTPResponse.error()
	var response = await http.request_completed
	return HTTPResponse.valid(response[0], response[1], response[2], response[3])

func upload_file(url: String, file_name: String, file_type: String, file_base64: String) -> HTTPResponse:
	const endpoint_argument_name: String = "model_file"
	var form: FormData = FormData.with_file(endpoint_argument_name, file_name, file_type, file_base64)
	return await http.send_raw(url, form.headers, HTTPClient.METHOD_POST, form.body)

func send_raw(url: String, headers: PackedStringArray, method: HTTPClient.Method, body: PackedByteArray) -> HTTPResponse:
	var error = http.request_raw(url, headers, method, body)
	if error != OK:
		push_error("Invalid request to %s" % url)
		return HTTPResponse.error()
	var response = await http.request_completed
	return HTTPResponse.valid(response[0], response[1], response[2], _body_from(response))

func _body_from(response: Array) -> Variant:
	var body: PackedByteArray = response[3]
	var json: JSON = JSON.new()
	json.parse(body.get_string_from_utf8())
	return json.data
