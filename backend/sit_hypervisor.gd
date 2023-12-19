class_name SITHypervisor
extends SITTranciever

#hypervisor interact signals
signal hv_heartbeat_received(message: String)
signal server_up_received(server_name: String)
signal server_down_received(server_name: String)
signal server_list_received(server_list: Array)

const EXCHANGE_TYPE = "/exchange/"
const HYPERVISOR_SEND_PATH : String  = EXCHANGE_TYPE + "hypervisor"
const HYPERVISOR_SUBSCRIBE_PATH : String = EXCHANGE_TYPE + "godot/hypervisor"

var servers : Dictionary = {} #"name": SITServer
var peers : Dictionary = {} #"id":"server_name"

func _init(stomp: STOMPClient):
	super._init(HYPERVISOR_SEND_PATH, HYPERVISOR_SUBSCRIBE_PATH, stomp)
	RPC.join_server_requested.connect(_on_user_join_server_requested)
	RPC.leave_server_requested.connect(_on_user_leave_server_requested)
	RPC.server_control_requested.connect(_on_user_server_control)
	RPC.cursor_position_updated.connect(_on_user_cursor)
	RPC.request_signal_list_updated.connect(_on_user_request_signal_list_updated)
	
func get_servers_statistic():
	var d : Dictionary = {}
	for s in servers:
		d[s] = servers[s].get_statistics()
	return d
	
func get_peers():
	return peers
	
func peer_connected(id: int):
	peers[id] = ""
	
func peer_disconnected(id: int):
	if peers[id] != "":
		_on_user_leave_server_requested(id)
	peers.erase(id)
		
func get_servers():
	return servers.keys()

var server_list_reply_to_id : int = 0
func get_server_list(id: int):
	server_list_reply_to_id = id
	var packet: String = JSON.stringify(make_request("get_server_list", null, 0))
	send( STOMPPacket.to(send_path).with_message(packet) )
	#FIXME: wait for HV response?
	RPC.send_server_list.rpc_id(id, servers.keys())
	
func create_server(server_name: String, file: String):
	var packet: String = JSON.stringify(make_request("create_server", [server_name, file], 0))
	send( STOMPPacket.to(send_path).with_message(packet) )
	
func kill_server(server_name: String):
	#first kick users
	servers[server_name].drop_users()
	var packet: String = JSON.stringify(make_request("kill_server", server_name, 0))
	send( STOMPPacket.to(send_path).with_message(packet) )

###JSON MAGIC
##hypervisor responses
func server_up(server_name: String):
	#charge new conversation with STOMP connection
	var srv : SITServer = SITServer.new(server_name, stomp)
	servers[server_name] = srv
	#TODO: all connections
	#TODO: correct server list and send peer news
	RPC.server_created.rpc(server_name)
	#updatea server_list
	server_up_received.emit(server_name)
	
func server_down(server_name: String):
	#srvs.erase(server_name)
	if server_name in servers:
		servers[server_name].free()
		servers.erase(server_name)
	for peer in peers: #reset peers 
		if peers[peer] == server_name:
			peers[peer] = ""
	RPC.server_killed.rpc(server_name)
	server_down_received.emit(server_name)

func server_list(srv_list: Array):
	#TODO: compare with actual list
	#decide what to do add or remove
	Log.trace("Sending server list to: %d" % server_list_reply_to_id)
	if server_list_reply_to_id:
		RPC.send_server_list.rpc_id(server_list_reply_to_id, srv_list)
		server_list_reply_to_id = 0
	else:
		RPC.send_server_list.rpc(srv_list)
	server_list_received.emit(srv_list)
	
func hv_heartbeat(message: String):
	hv_heartbeat_received.emit(message)
	
###RPC USERS REQUESTS
func _on_user_join_server_requested(server_name: String, user_name: String, id: int):
	if not server_name in servers:
		RPC.reject_join_server.rpc_id(id, "There's no server %s" % server_name)
	#Check already connected
	if peers[id] != "":
		RPC.reject_join_server.rpc_id(id, "Already on server %s" % peers[id])
	var reason = servers[server_name].join_user(user_name, id)
	if reason == "":
		peers[id] = server_name
	else:
		RPC.reject_join_server.rpc_id(id, reason)
		
func _on_user_leave_server_requested(id: int):
	if not id in peers:
		return
	if servers[peers[id]].leave_user(id):
		peers[id] = ""

func _on_user_server_control(server_name: String, action: String):
	if server_name in servers:
		servers[server_name].server_control(action)
		Log.trace("Server %s will be %s " % [server_name, action])
	else:
		Log.trace("There is no server: %s " % server_name)
	
func _on_user_cursor(pos: Vector2, id: int):
	if id in peers and peers[id] != "":
		servers[peers[id]].cursor_updated(pos, id)
	
func _on_user_request_signal_list_updated(sig_list: Array, id: int, _op: int):
	if id in peers and peers[id] != "":
		servers[peers[id]].user_signal_list(sig_list, id, _op)

func _on_user_signal_values_offered(signals: Dictionary, id: int):
	if id in peers and peers[id] != "":
		servers[peers[id]].user_signal_values(signals, id)
