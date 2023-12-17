extends Node

@onready var peer : ENetMultiplayerPeer
var ui_update_timer: Timer

const SERV_DREW = "46.138.251.6:55513" 
const SERV_LAN = "192.168.100.157:12313"
const SERV_WEB_LAN = "ws://192.168.100.157:123123/ws"
const LAN_LOGIN = "admin"
const LAN_PASS = "105Admin105"
const DRWE_LOGIN_PASS = "guest1"

const SERVER_PORT = 10508
const POLL_TIMEOUT = 0.05 #s
const AMQP_ADDRESS : String = SERV_DREW
const AMQP_WEB_ADDRESS : String = SERV_WEB_LAN
const AMQP_HOST : String = "/"
const AMQP_LOGIN : String = DRWE_LOGIN_PASS
const AMPQ_PASS : String = DRWE_LOGIN_PASS
const EXCHANGE_TYPE = "/exchange/"
const SERVER_SEND_PATH : String      = EXCHANGE_TYPE + "server/"
const SERVER_SUBSCRIBE_PATH : String = EXCHANGE_TYPE + "godot/"
const SERVERS_SEND_PATH : String     = EXCHANGE_TYPE + "servers/"
const HYPERVISOR_SEND_PATH : String  = EXCHANGE_TYPE + "hypervisor"
const HYPERVISOR_SUBSCRIBE_PATH : String = EXCHANGE_TYPE + "godot/hypervisor"
const HYPERVISOR_CHECK_TIMEOUT = 60.0

var is_sit_connected : bool = false

#for STOMP request
signal request_post_signals_into_server(server_name: String, signals: Dictionary)
#@onready var sit_manager : SITManager
var hypervisor: SITTranciever
#var servers : Array[SITManager] = []


#Links to the hypervisor or servers
var servers_link : Dictionary = {}  # {"server_name": SITTranciever}f 
#users peer ids  with them servers and usernames
var peers_server = {}  # {id: {"server": server_name, "user": user_name} }
#server with them signals
var srvs : Dictionary = {  #{ "srvname":  {"signame": [peer1, peern]}}
	"DUMMY" : {}
}

var peers_signals: Dictionary = {}
var stomp : STOMPClient = null

###main part---------------------------------------------------------------------------------
func _ready():
	begin_serve()   #FIRST give clients passability to interact server
	_on_sit_connect(RPC.CONNECTION_TCP)  #SECOND connect to AMQP
	$UI_update.start(1.0) #interface view internal status

var poll_timer = 0
func _process(delta):
	poll_timer += delta
	if poll_timer >= POLL_TIMEOUT:
		if stomp:
			stomp.poll()
		poll_timer = 0

func _on_ui_update_timeout():
	$users.text = JSON.stringify(peers_server,"\t")
	$signals.text = JSON.stringify(srvs, "\t")
	$links.text = JSON.stringify(servers_link, "\t")
	
func begin_serve():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(SERVER_PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	RPC.server_list_requested.connect(_on_server_list_requested)
	RPC.join_server_requested.connect(_on_join_server_requested)
	RPC.leave_server_requested.connect(_on_leave_server_requested)
	RPC.request_signal_list_updated.connect(_on_request_signal_list_updated)
	RPC.signal_values_offered.connect(_on_signal_values_offered)
	RPC.cursor_position_updated.connect(_on_user_cursor)
	
	RPC.create_server_requested.connect(_on_server_create)
	RPC.kill_server_requested.connect(_on_kill_server)
	RPC.server_control_requested.connect(_on_server_control)
	RPC.sit_connection_status_requested.connect(_on_sit_connection_status)
	RPC.sit_connection_requested.connect(_on_sit_connect)
	
	#multiplayer.get_peers()
	request_post_signals_into_server.connect(_ON_request_post_signals_into_server)
	
###Connection part---------------------------------------------------------------------------------
	
func _on_sit_connect(method: int):
	if is_sit_connected:
		return
	if method == RPC.CONNECTION_TCP:
		stomp = STOMP.over_tcp()
		is_sit_connected = await connect_to_server(stomp, AMQP_ADDRESS, AMQP_HOST, AMQP_LOGIN, AMPQ_PASS)
	else:
		stomp = STOMP.over_websockets()
		is_sit_connected = await connect_to_server(stomp, AMQP_ADDRESS, AMQP_HOST, AMQP_LOGIN, AMPQ_PASS)
	
	if not is_sit_connected:
		RPC.sit_connection_status.rpc(is_sit_connected)
		return
	hypervisor = create_hv_link()
	$Hypervisor_alive.start(HYPERVISOR_CHECK_TIMEOUT)
	hypervisor.get_server_list()


signal connection_result(ok: bool) #one shot signal
func connect_to_server(stomp: STOMPClient, address: String, host: String, login: String, password: String):
	var error = stomp.connect_to_host(address)
	if error != OK:
		Log.error("Не удалось подключиться к RabbitMQ, код ошибки: %s" % error)
		return false
	await stomp.connection.connected
	var connection_packet = STOMPPacket.connection(host, login, password)
	stomp.received.connect(_on_connection_result)
	stomp.send(connection_packet)
	$Connection_checker.start(1.0)
	var result =  await connection_result #timout or connection
	stomp.received.disconnect(_on_connection_result)
	return result
	
func disconnect_from_server():
	if stomp:
		stomp.send_disconnection()
	
#one shot callback function on connection if not delayed
func _on_connection_result(packet: STOMPPacket):
	$Connection_checker.stop()
	Log.trace("Сообщение от сервера RabbitMQ: %s" % packet.to_string())
	connection_result.emit(true)
	
#one shot timer STOMP connection
func _on_connection_checker_timeout():
	Log.debug("STOMP connection timeout")
	connection_result.emit(false)
	
func _on_sit_connection_status():
	RPC.sit_connection_status.rpc(is_sit_connected)
	
###AMQP interaction part --------------------------------------------------------------------------
	
func handle_link(connection: SITTranciever):
	stomp.send(connection.get_subscribe_packet())
	#stomp.subscribe(connection.get_subscribe_path(), connection.get_id())
	stomp.listen(connection.get_subscribe_path(), connection.get_listen_function())
	connection.send.connect(stomp.send)
	pass
	
func unhandle_link(connection: SITTranciever):
	stomp.unsubscribe(connection.get_id())
	stomp.unlisten(connection.get_recieve_path(), connection.get_listen_function())
	connection.send.disconnect(stomp.send)
	pass
	
	
func create_server_link(server_name: String) -> SITTranciever:
	var sc : SITTranciever = SITTranciever.new(SERVERS_SEND_PATH + server_name, SERVER_SUBSCRIBE_PATH + server_name)
	handle_link(sc)
	sc.update_signals_received.connect(_on_update_signal_received)
	#TODO: all connections
	return sc
	
func create_hv_link() -> SITTranciever:
	var sc : SITTranciever = SITTranciever.new(HYPERVISOR_SEND_PATH, HYPERVISOR_SUBSCRIBE_PATH)
	sc.server_up_received.connect(_on_server_up)
	sc.server_down_received.connect(_on_server_down)
	sc.server_list_received.connect(_on_server_list)
	sc.hv_heartbeat_received.connect(_on_hv_heartbeat)
	#TODO: moar connections
	handle_link(sc)
	return sc

##Hypervisor interaciton part ----------------------------------------------------------------------

#from client
var server_list_reply_to_id : int = 0
func _on_server_list_requested(id: int):
	server_list_reply_to_id = id
	hypervisor.get_server_list() #UPDATE server list
	#FIXME: wait for HV response?
	RPC.send_server_list.rpc(srvs.keys())

#from hypervisor
func _on_server_list(servers: Array):
	#TODO: compare with actual list
	#decide what to do add or remove
	Log.trace("Sending server list to: %d" % server_list_reply_to_id)
	if server_list_reply_to_id:
		RPC.send_server_list.rpc_id(server_list_reply_to_id, servers)
		server_list_reply_to_id = 0
	else:
		RPC.send_server_list.rpc(servers)
	
#reset timer on heartbeat
func _on_hv_heartbeat(message: String):
	$Hypervisor_alive.start(HYPERVISOR_CHECK_TIMEOUT)
	
func _on_hypervisor_alive_timeout():
	#TODO: clean????
	RPC.hypervisor_down.rpc()
	Log.trace("Warning! Hypervisor is not response")
	
#from client
func _on_server_create(server_name: String, file: String):
	hypervisor.create_server(server_name, file)
	
#from hypervisor
func _on_server_up(server_name: String):
	#charge new conversation with STOMP connection
	servers_link[server_name] = create_server_link(server_name)
	srvs[server_name] = {}
	#TODO: correct server list and send peer news
	RPC.server_created.rpc(server_name)
	#updatea server_list
	hypervisor.get_server_list() 
	
#from client
func _on_kill_server(server_name: String):
	hypervisor.kill_server(server_name)
	#first kick users
	for id in peers_server:
		if peers_server[id]["server"] == server_name:
			RPC.kick_peer.rpc_id(id, "Server is down")
	RPC.server_unavailable.rpc(server_name)
	
#from hypervisor
func _on_server_down(server_name: String):
	srvs.erase(server_name)
	unhandle_link(servers_link[server_name])
	servers_link[server_name].free()
	servers_link.erase(server_name)
	hypervisor.get_server_list()
	RPC.server_down.rpc(server_name)
	
##Server interaction part --------------------------------------------------------------------------
	
func _on_update_signal_received(server_name: String, signals: Dictionary):
	for id in peers_server:
		if peers_server[id]["server"] == server_name:
			RPC.set_signal_values.rpc_id(id, signals)

func send_signals_anyone_at(srv: String, sigs: Dictionary):
	for cli in peers_server:
		if peers_server[cli]["server"] == srv:
			RPC.set_fe_peer_signal_values.rpc_id(cli, sigs)

#multiplayer callback
func _on_peer_connected(id: int):
	print("New frontend connected: ", id)
	var pl = multiplayer.get_peers()
	peers_server[id] = {
		"server" : "",
		"user" : "",
		"cursor" : Vector2.ZERO
	}
	print("Peer count: ", pl.size())
	pass
	
func _on_peer_disconnected(id: int):
	print("Some frontend disconnected: ", id)
	var pl = multiplayer.get_peers()
	var sn = peers_server[id]["server"]
	if sn != "": #if disconnected without leave server
		_on_leave_server_requested(id)
	peers_server.erase(id)
	Log.trace("Peer count: %d" % pl.size())	
	pass
	
func _on_join_server_requested(server_name: String, user_name: String, id: int):
	#FIXME: check exists
	if not server_name in srvs: #FIXME: change in links?
		RPC.reject_join_server.rpc_id(id, "Server %s is absent" % server_name)
		return
	#Check already connected
	if peers_server[id]["server"] == server_name:
		RPC.reject_join_server.rpc_id(id, "Already on server")
	#TODO: Check user ID access rights
	var already_users = []
	for peer in peers_server:
		if peers_server[peer]["server"] == server_name:
			already_users.append(peers_server[peer]["user"])
			RPC.user_joined.rpc_id(peer, user_name) #inform already users new join
	RPC.grant_join_server.rpc_id(id, already_users)

	Log.trace("Peer %d joins %s" % [id, server_name])
	peers_server[id]["server"] = server_name
	peers_server[id]["user"] = user_name

	RPC.get_signals_list.rpc_id(id)  #FIXME:   fix it <-----------------------
	
func _on_leave_server_requested(id: int):
	var leaved_user = peers_server[id]["user"]
	var srv_name = peers_server[id]["server"]
	var srv_sigs = srvs[srv_name]
	print("Peer ", id, " leaves ", srv_name)
	for ps in srv_sigs:
		srv_sigs[ps].erase(id)
	cleanup_signals(srv_name)
	peers_server[id]["server"] = ""
	peers_server[id]["user"] = ""
	 #anounce leave every on same server
	for peer in peers_server:
		if peers_server[peer]["server"] == srv_name:
			RPC.user_leaved.rpc_id(peer, leaved_user)

#removes useless signals
func cleanup_signals(srver_name: String) -> bool: #true - need too update
	var result : bool = false
	var srv_sigs = srvs[srver_name]
	var keys = srv_sigs.keys() #for clean clearing
	for k in keys:
		if srv_sigs[k].is_empty():
			srv_sigs.erase(k)
			result = true
	return result

func _on_request_signal_list_updated(sig_list: Array, id: int, op: int):
	#FIXME: check
	#add new owner of signal
	var add_need_update = false
	var clean_need_update = false
	var srv_name = peers_server[id]["server"]
	var srv_sigs = srvs[srv_name]
	#cleanup id from every sig_info
	for ps in srv_sigs: 
		srv_sigs[ps].erase(id) #remove if was applied
	for sig in sig_list:
		if sig in srv_sigs:
			srv_sigs[sig].append(id)
		else:
			srv_sigs[sig] = [id]
			add_need_update = true
	
	clean_need_update = cleanup_signals(srv_name)
	if clean_need_update or add_need_update:
		if srv_name in servers_link:    #FIXME: remove 
			(servers_link[srv_name] as SITTranciever).set_signal_list(srv_sigs)
		
	var add = ""
	if clean_need_update:
		add = " cleaned unwanted"
	if add_need_update:
		add += " added new"
	if add == "":
		add = "nothing needed"
	print("Peer ", id, " updats signals: ", add)
	
#testing loopback model react immitation
func _ON_request_post_signals_into_server(srv: String, signals: Dictionary):
	for k in signals:
		if "_YB01" in k and signals[k][0] == true:
			var stat = k.replace("_YB01", "_is_state")
			send_signals_anyone_at(srv, {stat: [3]})
		if "_YB02" in k and signals[k][0] == true:
			var stat = k.replace("_YB02", "_is_state")
			send_signals_anyone_at(srv, {stat: [5]})
	
func _on_signal_values_offered(signals: Dictionary, id: int):
	var srv_name = peers_server[id]["server"]
	print("Peer ", id, " wants to do something nasty on ", srv_name)
	servers_link[srv_name].set_signals(signals)
	#request_post_signals_into_server.emit(srv_name, signals)     #FIXME: local loop

func process_incoming_signals(from_server: String, signals: Dictionary):
	print("Server ", from_server, "bring good news")
	for id in peers_server:
		if peers_server[id]["server"] == from_server:
			#TODO: cleanup peer list?
			print("..transfer updates to ", id)
			RPC.set_fe_peer_signal_values.rpc_id(id, signals)

func _on_server_control(server_name: String, action: String):
	(servers_link[server_name] as SITTranciever).server_control(action)
	
func _on_user_cursor(pos: Vector2, id: int):
	peers_server[id]["cursor"] = pos
	var server_name = peers_server[id]["server"]
	var user_name = peers_server[id]["user"]
	#anounce for another user of this server
	for peer in peers_server:
		#if peer == id: #skip self
		#	continue 
		if peers_server[peer]["server"] == server_name: #on the save server
			RPC.user_status.rpc(user_name, pos)
	
func _on_button_pressed():
	_on_server_create("hello", "asdfasdfasfd")
	pass # Replace with function body.
