class_name SITJSONRPC
extends JSONRPC

#hypervisor interact signals
signal server_up_received(server_name: String)
signal server_down_received(server_name: String)
signal server_list_received(server_name: String, server_list: Array)

# server interact signals
signal server_state_received(server_name: String)
signal update_signals_received(server_name: String, signals: Dictionary)

var _destinantion : String = "/temp-queue/"
var _reply: bool = false
const _reply_to: String = "/temp-queue/"
var _server_name : String = "DUMMY"

enum{EXCH_FANOUT, EXCH_DIRECT, EXCH_TOPIC, EXCH_QUEUE}
func _init(exchange_name: String, exchange_type: int = EXCH_QUEUE, target_server: String = "", reply: bool = false):
	_server_name = target_server #routing key
	match  exchange_type:
		EXCH_DIRECT, EXCH_FANOUT: #FIXME: destination variants
			_destinantion = "/exchange/"+exchange_name
		EXCH_QUEUE:
			_destinantion = "/queue/"+exchange_name
		EXCH_TOPIC:
			_destinantion = "/topic/"+exchange_name
	if target_server != "":
		_destinantion = _destinantion + "/" + target_server
#HV functions

func create_server(server_name: String, file: String):
	var packet: String = JSON.stringify(make_request("server_control", [server_name, file], 0))
	return STOMPPacket.to(_destinantion).with_message(packet)

func kill_server(server_name: String):
	var packet: String = JSON.stringify(make_request("server_control", server_name, 0))
	return STOMPPacket.to(_destinantion).with_message(packet)
	
func get_server_list():
	var packet: String = JSON.stringify(make_request("server_control", null, 0))
	return STOMPPacket.to(_destinantion).with_message(packet)


#func set_destination
	
#available: play, stop, pause, step, init
func server_control(action: String) -> STOMPPacket:
	var packet: String = JSON.stringify(make_request("server_control", action, 0))
	return STOMPPacket.to(_destinantion).with_message(packet)
	
func set_signal_list(signals: Dictionary) -> STOMPPacket:
	var packet: String = JSON.stringify(make_request("set_signal_list", signals, 0))
	return STOMPPacket.to(_destinantion).with_message(packet)

##hypervisor responses

func server_up(server_name: String):
	server_up_received.emit(server_name)
	
func server_down(server_name: String):
	server_down_received.emit(server_name)

func server_list(servers: Array):
	server_list_received.emit(servers)


##server responses
func server_state(state: Array):
	server_state_received.emit(_server_name, state)

func update_signals(signals: Dictionary):
	server_state_received.emit(_server_name, signals)

#magic JSONRPC function
func execute(sp: STOMPPacket):
	process_string(sp.body)
	
func get_subscribe_packet():
	return STOMPPacket.subscribe(_destinantion, str(get_instance_id()), "no-ack")

func get_unsubscribe_packet():
	return STOMPPacket.unsubscribe(str(get_instance_id()))

func get_path() -> String:
	return _destinantion

func get_listen_function() -> Callable:
	return execute
