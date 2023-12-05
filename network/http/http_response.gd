class_name HTTPResponse
extends RefCounted

var result: int
var status_code: int
var headers: PackedStringArray
var content: Variant

func is_not_found() -> bool:
	return str(status_code) == "404"

func is_success() -> bool:
	return str(status_code) == "200"

func is_error() -> bool:
	return !is_success()

func _to_string() -> String:
	return "Status: %s; Content: %s" % [status_code, content]

static func error() -> HTTPResponse:
	return HTTPResponse.new()

static func valid(result: int, status_code: int, headers: PackedStringArray, content: Variant) -> HTTPResponse:
	var response: HTTPResponse = HTTPResponse.new()
	response.result = result
	response.status_code = status_code
	response.headers = headers
	response.content = content
	return response
