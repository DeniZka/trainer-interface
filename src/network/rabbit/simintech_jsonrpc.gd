class_name SimintechJSONRPC
extends JSONRPC

const RABBIT_MQ_ADDRESS: String = "ws://192.168.100.157:15674/ws" 
const GODOT_RESPONSES: String = "/temp-queue/godot"

signal something_received(packet: STOMPPacket)
signal signals_recevied(server: String, signals: Dictionary)
var default_route : String = "/exchange/sit_cmds_exch/"

var stomp: STOMPClient

#ACHTUNG! IMPORTANT UPDATE FUNCTION NO HONEY WITHOUT!!!
func poll():
	stomp.poll()

func free():
	stomp.close()

func initialize() -> void:
	stomp = STOMP.over_websockets()
	stomp.received.connect(_on_received)
	await connect_to_server()
	await subscribe_to()

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

func subscribe_to(topic: String = "/temp-queue/godot") -> void:
	Log.debug("Подписка к обмену: %s" % topic)
	var subscribe_packet = STOMPPacket.subscribe(topic, str(0), "no-ack")
	Log.trace(subscribe_packet.to_string())
	stomp.send(subscribe_packet)
	stomp.listen(topic, _on_received)
	
func unsubscribe_from(topic: String = "/temp-queue/godot") -> void:
	var unsub = STOMPPacket.unsubscribe(topic)
	
func set_default_route(route: String = "/exchange/sit_cmds_exch/"):
	default_route = route
	
func send_simintech_packet(destination: String, packet: String):
	var stomp_packet: STOMPPacket = STOMPPacket.to(destination).with_message(packet).reply_to(GODOT_RESPONSES)
	Log.trace("Отправлен пакет %s" % stomp_packet)
	stomp.send(stomp_packet)
	
#functions
	
func read_db_signal_arr(server: String, signal_names: Array[String], id: int = 0) -> void:
	var packet: String = JSON.stringify(make_request("read_db_signal_arr", signal_names, id))
	send_simintech_packet(default_route + server, packet)
	
## routing_key is something like "sit_project_1b" from RabbitMQ 
func write_db_signal_arr(server: String, signals: Dictionary, id: int = 0) -> void:
	var packet: String = JSON.stringify(make_request("write_db_signal_arr", signals, id))
	send_simintech_packet(default_route + server, packet)
	
func set_read_db_signals_regular_task(server: String, signals: Dictionary, id: int = 0) -> void:
	var packet: String = JSON.stringify(make_request("set_read_db_signals_regular_task", signals, id))
	send_simintech_packet(default_route + server, packet)
	
#TODO: MANY NEW EXCHANGES


func _on_received(packet: STOMPPacket) -> void:
	Log.trace("Принят пакет: %s" % packet)
	something_received.emit(packet)
	
	if !(packet.headers.has("subscription") && packet.headers["subscription"] == GODOT_RESPONSES):
		return
		
	var result = JSON.parse_string(process_string(packet.body))
	Log.trace("Response fr")
	
