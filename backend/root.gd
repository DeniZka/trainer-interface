extends Node

@onready var peer : ENetMultiplayerPeer
var fe_peers : Array = [] #frontend peers
var timer: Timer

#for STOMP request
signal request_new_signal_list_from_server(server_name: String, sig_list: Array)
signal request_post_signals_into_server(server_name: String, signals: Dictionary)
@onready var sit_manager: SITManager = $SITManager
#functions
#process_incoming_signals(from_server: String, signals: Dictionary)

var peers_server = {  #id: "server_name"
	
}

var srvs : Dictionary = {  #{ "srvname":  {"signame": [peer1, peern]}}
	"DUMMY" : {  
	}
}
var peers_signals: Dictionary = {}

func _ready():
	#NOTE: interface updatetion timer
	timer = Timer.new()
	timer.one_shot = false
	timer.timeout.connect(timer_timout)
	add_child(timer)
	timer.start(1.0)
	
	await sit_manager.connect_to_server("ws://192.168.100.157:15674/ws")#"192.168.100.157:61613")
	sit_manager.connect_to_hypervisor()
	
	#create server
	peer = ENetMultiplayerPeer.new()
	peer.create_server(10508)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	RPC.join_server_requested.connect(_on_join_server_requested)
	RPC.leave_server_requested.connect(_on_leave_server_requested)
	RPC.request_signal_list_updated.connect(_on_request_signal_list_updated)
	RPC.signal_values_offered.connect(_on_signal_values_offered)
	RPC.server_list_requested.connect(_on_server_list_requested)
	RPC.create_server_requested.connect(_on_server_create)
	#multiplayer.get_peers()
	request_post_signals_into_server.connect(_ON_request_post_signals_into_server)

func send_signals_anyone_at(srv: String, sigs: Dictionary):
	for cli in peers_server:
		if peers_server[cli] == srv:
			RPC.set_fe_peer_signal_values.rpc_id(cli, sigs)	

#testing loopback model react immitation
func _ON_request_post_signals_into_server(srv: String, signals: Dictionary):
	for k in signals:
		if "_YB01" in k and signals[k][0] == true:
			var stat = k.replace("_YB01", "_is_state")
			send_signals_anyone_at(srv, {stat: [3]})
		if "_YB02" in k and signals[k][0] == true:
			var stat = k.replace("_YB02", "_is_state")
			send_signals_anyone_at(srv, {stat: [5]})

func timer_timout():
	$users.text = JSON.stringify(peers_server,"\t")
	$signals.text = JSON.stringify(srvs, "\t")
	
func _on_server_create(server_name: String, file: String):
	sit_manager.create_server(server_name, file)
	pass

func _on_peer_connected(id: int):
	print("New frontend connected: ", id)
	var pl = multiplayer.get_peers()
	peers_server[id] = "" #register peer in list
	print("Peer count: ", pl.size())
	pass
	
func _on_peer_disconnected(id: int):
	print("Some frontend disconnected: ", id)
	var pl = multiplayer.get_peers()
	var sn = peers_server[id]
	if sn != "": #if disconnected without leave server
		_on_leave_server_requested(id)
	peers_server.erase(id)
	print("Peer count: ", pl.size())	
	pass
	
func _on_join_server_requested(server_name: String, id: int):
	#FIXME: check exists
	print("Peer ", id, " joins ", server_name)
	peers_server[id] = server_name
	RPC.grant_join_server.rpc_id(id)
	RPC.get_fe_peer_signal_list.rpc_id(id)
	
	
func _on_leave_server_requested(id: int):
	var srv_name = peers_server[id]
	var srv_sigs = srvs[srv_name]
	print("Peer ", id, " leaves ", srv_name)
	for ps in srv_sigs:
		srv_sigs[ps].erase(id)
	cleanup_signals(srv_name)
	peers_server[id] = ""

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
	var srv_name = peers_server[id]
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
		request_new_signal_list_from_server.emit(srv_name, srv_sigs.keys())
		
	var add = ""
	if clean_need_update:
		add = " cleaned unwanted"
	if add_need_update:
		add += " added new"
	if add == "":
		add = "nothing needed"
	print("Peer ", id, " updats signals: ", add)
	
func _on_signal_values_offered(signals: Dictionary, id: int):
	var srv_name = peers_server[id]
	print("Peer ", id, " wants to do something nasty on ", srv_name)
	request_post_signals_into_server.emit(srv_name, signals)

func process_incoming_signals(from_server: String, signals: Dictionary):
	print("Server ", from_server, "bring good news")
	for id in peers_server:
		if peers_server[id] == from_server:
			#TODO: cleanup peer list?
			print("..transfer updates to ", id)
			RPC.set_fe_peer_signal_values.rpc_id(id, signals)
			
func _on_server_list_requested(id: int):
	#FIXME: available only!!
	print("Sending server list to ", id)
	RPC.send_server_list.rpc_id(id, srvs.keys())
