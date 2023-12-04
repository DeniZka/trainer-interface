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

func send(url: String, method: HTTPClient.Method, headers: PackedStringArray = []) -> HTTPResponse:
	var error = http.request(url, headers, method)
	if error != OK:
		push_error("Invalid request to %s" % url)
		return HTTPResponse.error()
	
	var response = await http.request_completed
	return HTTPResponse.valid(response[1], _body_from(response))

func _body_from(response: Array) -> Variant:
	var body: PackedByteArray = response[3]
	var json: JSON = JSON.new()
	json.parse(body.get_string_from_utf8())
	return json.data
