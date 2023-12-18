class_name HTTPRequestPool
extends Node

var pool: Array[HTTPRequest]
var timeout: float

func _init(timeout: float) -> void:
	self.timeout = timeout

func pop() -> HTTPRequest:
	if pool.size() > 0:
		return pool.pop_back()
	return _create_http_request()

func push(request: HTTPRequest) -> void:
	pool.push_back(request)

func _create_http_request() -> HTTPRequest:
	var request = HTTPRequest.new()
	request.set_tls_options(TLSOptions.client_unsafe())
	request.timeout = timeout
	#request.use_threads = true
	add_child(request)
	return request
