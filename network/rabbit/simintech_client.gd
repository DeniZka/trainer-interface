class_name SimintechClient
extends Node

const RABBIT_MQ_ADDRESS: String = "ws://192.168.100.157:15674/ws" 
const GODOT_RESPONSES: String = "/exchange/frontend.responses/godot"

signal received(packet: SimintechResponse)
signal received_read_response(packet: ReadSignalsSimintechResponse)

@onready var stomp: STOMPClient = STOMP.over_websockets()

func _process(delta: float) -> void:
	stomp.poll()

func _exit_tree():
	stomp.close()

func initialize() -> void:
	await connect_to_server()
	await subscribe_to_exchange()
	await read_signals_test()
	#await write_signals_test()

func connect_to_server() -> void:
	Log.debug("Подключение к серверу RabbitMQ: %s" % RABBIT_MQ_ADDRESS)
	var error = stomp.connect_to_host(RABBIT_MQ_ADDRESS)
	if error != OK:
		Log.error("Не удалось подключиться к RabbitMQ, код ошибки: %s" % error)
		return
	await stomp.connection.connected
	var connection_packet = STOMPPacket.connection("/", "admin", "105Admin105")
	Log.trace("Отправка пакета соединения по протоколу STOMP 1.2: %s" % connection_packet)
	stomp.send(connection_packet)
	Log.trace("Ожидание ответа от сервера RabbitMQ...")
	# TODO: timeout for fixed endless awaiting
	var connected_packet: STOMPPacket = await stomp.received
	Log.trace("Сообщение от сервера RabbitMQ: %s" % connected_packet.to_string())
	Log.debug("Подключение к серверу RabbitMQ прошло успешно")

func subscribe_to_exchange() -> void:
	Log.debug("Подписка к обмену: %s" % GODOT_RESPONSES)
	var subscribe_packet = STOMPPacket.subscribe(GODOT_RESPONSES, str(0))
	Log.trace(subscribe_packet.to_string())
	stomp.send(subscribe_packet)
	stomp.listen(GODOT_RESPONSES, _on_received)

func read_signals_test() -> void:
	read_signals(0, "", ["test_0", "test_1"])
	var received: STOMPPacket = await stomp.received
	print(received)

func write_signals_test() -> void:
	write_signals(0, "", { "test_0": 0, "test_1": 1 })
	var received: STOMPPacket = await stomp.received
	print(received)

func read_signals(id: int, destination: String, signal_names: Array[String]) -> void:
	var read_packet: SimintechPacket = SimintechPacket.read_signals_from_db(id, signal_names)
	send_simintech_packet(destination, read_packet)

func write_signals(id: int, destination: String, signals_with_values: Dictionary) -> void:
	var write_packet: SimintechPacket = SimintechPacket.write_signals_to_db(id, signals_with_values)
	send_simintech_packet(destination, write_packet)

func send_simintech_packet(destination: String, packet: SimintechPacket) -> void:
	var stomp_packet: STOMPPacket = STOMPPacket.to(destination).with_message(packet.to_json()).reply_to(GODOT_RESPONSES)
	stomp.send(stomp_packet)

func _on_received(packet: STOMPPacket) -> void:
	Log.trace("Принят пакет: %s" % packet)
	var content: Dictionary = JSON.parse_string(packet.body)
	var response: SimintechResponse
	
	if content.has("cmd") and content["cmd"] == ReadSignalsSimintechCommand.type_name:
		response = ReadSignalsSimintechResponse.create_from_json(content)
		received_read_response.emit(response)
	else:
		response = SimintechResponse.create_from_json(content)
	
	Log.trace("Пакет после парсинга: %s" % response)
	received.emit(response)


