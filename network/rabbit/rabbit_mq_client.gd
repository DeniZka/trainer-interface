class_name RabbitMqClient
extends Node

const RABBIT_MQ_ADDRESS: String = "ws://192.168.100.157:15674/ws" 
const GODOT_RESPONSES: String = "/exchange/frontend.responses/godot"

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
	var subscribe_packet = STOMPPacket.subscribe(GODOT_RESPONSES, str(0))
	Log.trace(subscribe_packet.to_string())
	stomp.send(subscribe_packet)

func _on_received(packet: STOMPPacket) -> void:
	Log.trace("[Rabbit Mq] Принят пакет: %s" % packet)
