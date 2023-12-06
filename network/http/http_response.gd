class_name HTTPResponse
extends RefCounted

var result: int
var status_code: int
var headers: PackedStringArray
var content: Variant

func is_not_found() -> bool:
	return status_code == HTTPClient.RESPONSE_NOT_FOUND

func is_timeout_error() -> bool:
	return result == HTTPRequest.RESULT_TIMEOUT

func is_success() -> bool:
	return status_code == HTTPClient.RESPONSE_OK

func is_error() -> bool:
	return !is_success()

func parse_as_json() -> HTTPResponse:
	var parsed_content: Variant = content
	
	if content != null:
		parsed_content = _parse_json(content)
	
	return HTTPResponse.valid(result, status_code, headers, parsed_content)

func _parse_json(response: Variant) -> Variant:
	var json: JSON = JSON.new()
	json.parse(response.get_string_from_utf8())
	return json.data

func _to_string() -> String:
	return "Status: %s, %s" % [status_code, content]

static func error() -> HTTPResponse:
	return HTTPResponse.new()

static func valid(result: int, status_code: int, headers: PackedStringArray, content: Variant) -> HTTPResponse:
	var response: HTTPResponse = HTTPResponse.new()
	response.result = result
	response.status_code = status_code
	response.headers = headers
	response.content = content
	return response
