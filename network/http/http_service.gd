class_name HTTPService
extends RefCounted

var pool: HTTPRequestPool

func _init(pool: HTTPRequestPool) -> void:
	self.pool = pool

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
	return null
	#return await http.send_raw(url, form.headers, HTTPClient.METHOD_POST, form.body)

func _send_exchange(url: String, headers: PackedStringArray, method: HTTPClient.Method, body: PackedByteArray) -> HTTPResponse:
	Log.trace("Установка соединения с сервером, %s" % url)
	var response: HTTPResponse = await _exchange(url, headers, method, body)
	Log.trace("Окончание обмена информацией с сервером, %s" % url)
	if not response.is_success():
		Log.error("Не валидный ответ с сервера: %s" % response.parse_as_json())
	return response

func _exchange(url: String, headers: PackedStringArray, method: HTTPClient.Method, body: PackedByteArray) -> HTTPResponse:
	var http: HTTPRequest = pool.pop()
	var error = http.request_raw(url, headers, method, body)
	if error != OK:
		Log.error("Не удалось установить соединение с сервером (%s). Код ошибки: %s" % [url, error])
		return HTTPResponse.error()
	var raw = await http.request_completed
	pool.push(http)
	return HTTPResponse.valid(raw[0], raw[1], raw[2], raw[3])
