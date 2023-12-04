class_name HTTPResponse
extends RefCounted

var code: int
var content: Variant

func is_not_found() -> bool:
	return str(code) == "404"

func is_success() -> bool:
	return str(code) == "200"

func is_error() -> bool:
	return !is_success()

static func error() -> HTTPResponse:
	return HTTPResponse.new()

static func valid(code: int, content: Variant) -> HTTPResponse:
	var response: HTTPResponse = HTTPResponse.new()
	response.code = code
	response.content = content
	return response
