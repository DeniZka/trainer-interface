class_name HTTPRequestPool
extends Node

var pool: Array[HTTPRequest]
var timeout: float

func _init(timeout: float) -> void:
	self.timeout = timeout

func pop() -> HTTPRequest:
	if pool.size() > 0:
		var result: HTTPRequest = pool[0]
		pool.remove_at(0)
		return result

	return _create_http_request(timeout)

func push(request: HTTPRequest) -> void:
	pool.append(request)

func _create_http_request(timeout: float) -> HTTPRequest:
	var request = HTTPRequest.new()
	request.set_tls_options(TLSOptions.client_unsafe())
	request.timeout = timeout
	#request.use_threads = true
	add_child(request)
	return request
