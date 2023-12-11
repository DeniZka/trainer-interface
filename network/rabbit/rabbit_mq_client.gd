class_name RabbitMqClient
extends Node

const RABBIT_MQ_ADDRESS: String = "ws://192.168.100.157:15674/ws" 

var stomp: STOMPClient

func _ready() -> void:
	stomp = STOMP.over_websockets()
	await connect_to_server()

func _process(delta: float) -> void:
	stomp.poll()

func connect_to_server() -> void:
	Log.trace("Подключение к серверу RabbitMQ: %s" % RABBIT_MQ_ADDRESS)
	var error = stomp.connect_to_host(RABBIT_MQ_ADDRESS)
	if error != OK:
		Log.error("Не удалось подключиться к RabbitMQ")
		return
	await stomp.connection.connected
	var connection_packet = STOMPPacket.connection("/", "admin", "105Admin105")
	Log.trace("Отправка пакета соединения по протоколу STOMP 1.2: %s" % connection_packet)
	stomp.send(connection_packet)
	Log.trace("Ожидание ответа от сервера RabbitMQ...")
	# TODO: timeout for fixed endless awaiting
	var connected_packet: STOMPPacket = await stomp.received
	Log.trace("Сообщение от сервера RabbitMQ: %s" % connected_packet.to_string())
	Log.trace("Подключение к серверу RabbitMQ прошло успешно")
