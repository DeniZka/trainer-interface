class_name HTTPService
extends RefCounted

var http: HTTPRequest
var response_awaiter: HTTPResponseAwaiter

func _init(http: HTTPRequest) -> void:
	self.http = http
	self.response_awaiter = HTTPResponseAwaiter.new()

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
	return await send_raw(url, headers, method, [])

func send_raw(url: String, headers: PackedStringArray, method: HTTPClient.Method, body: PackedByteArray) -> HTTPResponse:
	return await _send_exchange(url, headers, method, body)

func download_file(url: String) -> HTTPResponse:
	return await _send_exchange(url, [], HTTPClient.METHOD_GET, [])

func upload_file(url: String, file_name: String, file_type: String, file_base64: String) -> HTTPResponse:
	const endpoint_argument_name: String = "model_file"
	var form: FormData = FormData.with_file(endpoint_argument_name, file_name, file_type, file_base64)
	return await http.send_raw(url, form.headers, HTTPClient.METHOD_POST, form.body)

func _send_exchange(url: String, headers: PackedStringArray, method: HTTPClient.Method, body: PackedByteArray) -> HTTPResponse:
	Log.trace("Установка соединения с сервером, %s" % url)
	var error = http.request_raw(url, headers, method, body)
	if error != OK:
		_not_connection_log(url, error)
		return HTTPResponse.error()
	var response = await response_awaiter.await_response(http)
	Log.trace("Окончание обмена информацией с сервером, %s" % url)
	
	if not response.is_success():
		Log.error("Не валидный ответ с сервера: %s" % response.parse_as_json())
	
	return response

func _cancel_previous_request() -> void:
	http.request_completed.emit(0, 0, [], null)
	http.cancel_request()

func _not_connection_log(url: String, error: int) -> void:
	Log.error("Не удалось установить соединение с сервером (%s). Код ошибки: %s" % [url, error])
