class_name SITManager
extends Node

var stomp : STOMPClient = STOMP.over_tcp() #websockets() #tcp()
#const RABBIT_MQ_ADDRESS: String = "ws://192.168.100.157:15674/ws" 
@onready var hypervisor : SITTranciever
@onready var servers : Array = []

func _exit_tree():
	disconnect_from_server()
	for s in servers:
		s.free()
	servers = []
	hypervisor.free()

func disconnect_from_server():
	#FIXME: check stomp is connnected if !stomp.is_:
	#	return
	for s in servers:
		stomp.send(s.get_unsubscribe_packet())
	stomp.send(hypervisor.get_unsubscribe_packet())

func connect_to_server(address: String = "192.168.100.157:61613") -> void:
	Log.debug("Подключение к серверу RabbitMQ: %s" % address)
	var error = stomp.connect_to_host(address)
	if error != OK:
		Log.error("Не удалось подключиться к RabbitMQ, код ошибки: %s" % error)
		return
	await stomp.connection.connected
	var connection_packet = STOMPPacket.connection("/", "guest1", "guest1")#("/", "admin", "105Admin105")
	Log.trace("Отправка пакета соединения по протоколу STOMP 1.2: %s" % connection_packet)
	stomp.send(connection_packet)
	Log.trace("Ожидание ответа от сервера RabbitMQ...")
	# TODO: timeout for fixed endless awaiting
	var connected_packet: STOMPPacket = await stomp.received
	Log.trace("Сообщение от сервера RabbitMQ: %s" % connected_packet.to_string())
	Log.debug("Подключение к серверу RabbitMQ прошло успешно")
	hypervisor.send.connect(stomp.send)
	hypervisor.listen.connect(stomp.listen)
	#subscribe hypervisor


func handle_connection(server: SITTranciever):
	
	pass

func connect_to_hypervisor():
	#stomp.listen(hypervisor.get_path(), hypervisor.get_listen_function())	
	stomp.received.connect(_on_received)
	stomp.send(hypervisor.get_subscribe_packet()) #gives error
	stomp.send(hypervisor.get_server_list())


func subscribe_to(topic: String = "/temp-queue/godot") -> void:
	Log.debug("Подписка к обмену: %s" % topic)
	var subscribe_packet = STOMPPacket.subscribe(topic, str(0), "no-ack")
	Log.trace(subscribe_packet.to_string())
	stomp.send(subscribe_packet)
	stomp.listen(topic, _on_received)

func _process(delta):
	#stomp.poll()
	pass

func _on_received(packet: STOMPPacket):
	print(packet)
	pass
	
func create_server(server_name: String, file: String):
	#talk with hypervisor
	stomp.send(hypervisor.create_server(server_name, file))
	#talk with server
	#var srv : SITTranciever = SITTranciever.new("server", SITTranciever.EXCH_DIRECT, server_name)
	#srv.create_server(server_name, file)
	
