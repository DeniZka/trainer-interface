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
	return await send_raw(url, headers, method, [])

func send_raw(url: String, headers: PackedStringArray, method: HTTPClient.Method, body: PackedByteArray) -> HTTPResponse:
	var response = await _send_exchange(url, headers, method, body)
	return response.parse_as_json()

func download_file(url: String) -> HTTPResponse:
	return await _send_exchange(url, [], HTTPClient.METHOD_GET, [])

func upload_file(url: String, file_name: String, file_type: String, file_base64: String) -> HTTPResponse:
	const endpoint_argument_name: String = "model_file"
	var form: FormData = FormData.with_file(endpoint_argument_name, file_name, file_type, file_base64)
	return await http.send_raw(url, form.headers, HTTPClient.METHOD_POST, form.body)

func _send_exchange(url: String, headers: PackedStringArray, method: HTTPClient.Method, body: PackedByteArray) -> HTTPResponse:
	Log.debug("Установка соединения с сервером (%s)" % url)
	var error = http.request_raw(url, headers, method, body)
	if error != OK:
		_not_connection_log(url, error)
		return HTTPResponse.error()
	var response = await http.request_completed
	Log.debug("Окончание обмена информацией с сервером (%s)" % url)
	
	var http_response = HTTPResponse.valid(response[0], response[1], response[2], response[3])
	
	if not http_response.is_success():
		Log.error("Не валидный ответ с сервера: %s" % http_response.parse_as_json())
	
	return http_response

func _not_connection_log(url: String, error: int) -> void:
	Log.error("Не удалось установить соединение с сервером (%s). Код ошибки: %s" % [url, error])
