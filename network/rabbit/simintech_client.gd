class_name SimintechClient
extends Node

const RABBIT_MQ_ADDRESS: String = "ws://192.168.100.157:15674/ws" 
const GODOT_RESPONSES: String = "/temp-queue/godot"

signal received(packet: SimintechResponse)
signal received_read_response(packet: ReadSignalsSimintechResponse)

@onready var stomp: STOMPClient = STOMP.over_websockets()

func _process(delta: float) -> void:
	stomp.poll()

func _exit_tree():
	stomp.close()

func initialize() -> void:
	stomp.received.connect(_on_received)
	await connect_to_server()
	await subscribe_to_exchange()

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
	var subscribe_packet = STOMPPacket.subscribe(GODOT_RESPONSES, str(0), "no-ack")
	Log.trace(subscribe_packet.to_string())
	stomp.send(subscribe_packet)
	stomp.listen(GODOT_RESPONSES, _on_received)

## routing_key is something like "sit_project_1b" from RabbitMQ 
func read_signals(id: int, routing_key: String, signal_names: Array[String]) -> void:
	var destination: String = "/exchange/sit_cmds_exch/%s" % routing_key
	var read_packet: SimintechPacket = SimintechPacket.read_signals_from_db(id, signal_names)
	send_simintech_packet(destination, read_packet)

## routing_key is something like "sit_project_1b" from RabbitMQ 
func write_signals(id: int, routing_key: String, signals_with_values: Dictionary) -> void:
	var destination: String = "/exchange/sit_cmds_exch/%s" % routing_key
	var write_packet: SimintechPacket = SimintechPacket.write_signals_to_db(id, signals_with_values)
	send_simintech_packet(destination, write_packet)

func send_simintech_packet(destination: String, packet: SimintechPacket) -> void:
	var stomp_packet: STOMPPacket = STOMPPacket.to(destination).with_message(packet.to_json()).reply_to(GODOT_RESPONSES)
	Log.trace("Отправлен пакет %s" % stomp_packet)
	stomp.send(stomp_packet)

func _on_received(packet: STOMPPacket) -> void:
	Log.trace("Принят пакет: %s" % packet)
	
	if !(packet.headers.has("subscription") && packet.headers["subscription"] == GODOT_RESPONSES):
		return
	
	var content: Dictionary = JSON.parse_string(packet.body)
	var response: SimintechResponse
	
	if content.has("cmd") and content["cmd"] == ReadSignalsSimintechCommand.type_name:
		response = ReadSignalsSimintechResponse.create_from_json(content)
		received_read_response.emit(response)
	else:
		response = SimintechResponse.create_from_json(content)
	
	Log.trace("Пакет после парсинга: %s" % response)
	received.emit(response)


