class_name SITHypervisor
extends SITTranciever

#hypervisor interact signals
signal hv_heartbeat_received(message: String)
signal server_up_received(server_name: String)
signal server_down_received(server_name: String)
signal server_list_received(server_name: String, server_list: Array)

const EXCHANGE_TYPE = "/exchange/"
const HYPERVISOR_SEND_PATH : String  = EXCHANGE_TYPE + "hypervisor"
const HYPERVISOR_SUBSCRIBE_PATH : String = EXCHANGE_TYPE + "godot/hypervisor"

var servers : Dictionary = {} #"name": SITServer
var peers : Dictionary = {} #"id":"server_name"

func _init(stomp: STOMPClient):
	super._init(HYPERVISOR_SEND_PATH, HYPERVISOR_SUBSCRIBE_PATH, stomp)
	RPC.server_list_requested.connect(_on_user_server_list_requested)
	RPC.create_server_requested.connect(_on_user_server_create)
	RPC.kill_server_requested.connect(_on_user_kill_server)
	
func get_peers():
	return peers
	
func peer_connected(id: int):
	peers[id] = ""
	
func peer_disconnected(id: int):
	if peers[id] != "":
		servers[peers[id]].user_is_suddenly_disconnected(id)
		
func _on_user_joined(server_name: String, id: int):
	peers[id] = server_name
	
func _on_user_leave(server_name: String, id: int):
	peers[id] = ""
	
func get_servers():
	return servers.keys()

var server_list_reply_to_id : int = 0
func create_server(server_name: String, file: String):
	var packet: String = JSON.stringify(make_request("create_server", [server_name, file], 0))
	send.emit( STOMPPacket.to(send_path).with_message(packet) )

func kill_server(server_name: String):
	var packet: String = JSON.stringify(make_request("kill_server", server_name, 0))
	send.emit( STOMPPacket.to(send_path).with_message(packet) )
	
func get_server_list():
	var packet: String = JSON.stringify(make_request("get_server_list", null, 0))
	send.emit( STOMPPacket.to(send_path).with_message(packet) )


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
	get_server_list() 
	server_up_received.emit(server_name)
	
func server_down(server_name: String):
	#srvs.erase(server_name)
	if server_name in servers:
		servers[server_name].free()
		servers.erase(server_name)
	get_server_list()
	RPC.server_down.rpc(server_name)
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

func _on_user_server_list_requested(id: int):
	server_list_reply_to_id = id
	get_server_list() #UPDATE server list
	#FIXME: wait for HV response?
	RPC.send_server_list.rpc(servers.keys())
	
func _on_user_server_create(server_name: String, file: String):
	create_server(server_name, file)
	
func _on_user_kill_server(server_name: String):
	kill_server(server_name)
	#first kick users
	servers[server_name].drop_users()
	#TODO: remove server
