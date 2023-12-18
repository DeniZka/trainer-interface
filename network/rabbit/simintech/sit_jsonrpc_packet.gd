class_name SITTranciever
extends JSONRPC

#signal send(packet: STOMPPacket)

#var _reply: bool = false
#const _reply_to: String = "/temp-queue/"
var send_path : String
var subscribe_path : String

var queue_name : String = "DUMMY"
var stomp : STOMPClient

func _init(send_path: String, subscribe_path: String, stomp: STOMPClient):
	self.stomp = stomp
	self.send_path = send_path
	self.subscribe_path = subscribe_path
	self.queue_name = subscribe_path.split("/")[-1]
	stomp.listen(get_subscribe_path(), get_listen_function())
	stomp.send(get_subscribe_packet())

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		stomp.send(get_unsubscribe_packet())
		stomp.unlisten(get_subscribe_path(), get_listen_function())
	
func send(packet : STOMPPacket):
	stomp.send(packet)
	
#magic JSONRPC function
func execute(sp: STOMPPacket):
	process_string(sp.body)
	
func get_subscribe_packet() -> STOMPPacket:
	var sp : STOMPPacket = STOMPPacket.subscribe(subscribe_path, get_id())
	return sp.add_header("x-queue-name", "godot-" + queue_name)

func get_unsubscribe_packet():
	return STOMPPacket.unsubscribe(str(get_instance_id()))

func get_listen_function() -> Callable:
	return execute
	
func get_subscribe_path() -> String:
	return subscribe_path
	
func get_send_path() -> String:
	return send_path
	
func get_id() -> String:
	return str(get_instance_id())
