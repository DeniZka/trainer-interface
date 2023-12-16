class_name SITTranciever
extends JSONRPC

signal send(packet: STOMPPacket)
signal listen()

#hypervisor interact signals
signal hv_heartbeat_received(message: String)
signal server_up_received(server_name: String)
signal server_down_received(server_name: String)
signal server_list_received(server_name: String, server_list: Array)

# server interact signals
signal server_state_received(server_name: String)
signal update_signals_received(server_name: String, signals: Dictionary)

var _reply: bool = false
const _reply_to: String = "/temp-queue/"
var server_name : String = "DUMMY"
var send_path : String
var subscribe_path : String

func _init(send_path: String, subscribe_path: String):
	self.send_path = send_path
	self.subscribe_path = subscribe_path
	self.server_name = subscribe_path.split("/")[-1]

func create_server(server_name: String, file: String):
	var packet: String = JSON.stringify(make_request("create_server", [server_name, file], 0))
	send.emit( STOMPPacket.to(send_path).with_message(packet) )

func kill_server(server_name: String):
	var packet: String = JSON.stringify(make_request("kill_server", server_name, 0))
	send.emit( STOMPPacket.to(send_path).with_message(packet) )
	
func get_server_list():
	var packet: String = JSON.stringify(make_request("get_server_list", null, 0))
	send.emit( STOMPPacket.to(send_path).with_message(packet) )


#func set_destination
	
#available: play, stop, pause, step, init
func server_control(action: String):
	var packet: String = JSON.stringify(make_request("server_control", action, 0))
	send.emit( STOMPPacket.to(send_path).with_message(packet) )
	
func set_signal_list(signals: Dictionary):
	var packet: String = JSON.stringify(make_request("set_signal_list", signals, 0))
	send.emit( STOMPPacket.to(send_path).with_message(packet) )

##hypervisor responses

func server_up(server_name: String):
	server_up_received.emit(server_name)
	
func server_down(server_name: String):
	server_down_received.emit(server_name)

func server_list(servers: Array):
	server_list_received.emit(servers)
	
func hv_heartbeat(message: String):
	hv_heartbeat_received.emit(message)


##server responses
func server_state(state: Array):
	server_state_received.emit(server_name, state)

func update_signals(signals: Dictionary):
	server_state_received.emit(server_name, signals)

#magic JSONRPC function
func execute(sp: STOMPPacket):
	process_string(sp.body)
	
func get_subscribe_packet() -> STOMPPacket:
	var sp : STOMPPacket = STOMPPacket.subscribe(subscribe_path, str(get_instance_id()))
	return sp.add_header("x-queue-name", "godot-" + server_name)

func get_unsubscribe_packet():
	return STOMPPacket.unsubscribe(str(get_instance_id()))

#func get_path() -> String:
#	return _destinantion

func get_listen_function() -> Callable:
	return execute
	
func get_subscribe_path() -> String:
	return subscribe_path
	
func get_send_path() -> String:
	return send_path
	
func get_id() -> String:
	return str(get_instance_id())
