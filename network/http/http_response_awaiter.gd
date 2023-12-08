class_name HTTPResponseAwaiter
extends RefCounted

signal request_completed(response: HTTPResponse)

func await_response(request: HTTPRequest) -> HTTPResponse:
	request.request_completed.connect(_on_request_completed)
	var response = await request_completed
	request.request_completed.disconnect(_on_request_completed)
	return response

func _on_request_completed(result: int, status_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = HTTPResponse.valid(result, status_code, headers, body)
	request_completed.emit(response)
