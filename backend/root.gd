extends Node

@onready var peer : ENetMultiplayerPeer
var fe_peers : Array = [] #frontend peers

#for STOMP request
signal request_new_signal_list_from_server(server_name: String, sig_list: Array)
signal request_post_signals_into_server(server_name: String, signals: Dictionary)

#functions
#process_incoming_signals(from_server: String, signals: Dictionary)

var peers_server = {  #id: "server_name"
	
}

var srvs : Dictionary = {  #{ "srvname":  {"signame": [peer1, peern]}}
	"DUMMY" : {  
	}
}

#
var peers_signals: Dictionary = {}

func _ready():
	#create server
	peer = ENetMultiplayerPeer.new()
	peer.create_server(10508)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_new_fe_peer_info)
	multiplayer.peer_disconnected.connect(remove_lost_fe_peer_info)
	RPC.join_server_requested.connect(join_peer_to_server)
	RPC.leave_server_requested.connect(remove_peer_from_server)
	RPC.request_signal_list_updated.connect(update_fe_peer_signal_list)
	RPC.signal_values_offered.connect(add_fe_peer_outgoing_signals)
	RPC.server_list_requested.connect(send_server_list)
	#multiplayer.get_peers()


func add_new_fe_peer_info(id: int):
	print("New frontend connected: ", id)
	var pl = multiplayer.get_peers()
	print("Peer count: ", pl.size())
	pass
	
func remove_lost_fe_peer_info(id: int):
	print("Some frontend disconnected: ", id)
	var pl = multiplayer.get_peers()
	print("Peer count: ", pl.size())	
	pass
	
func join_peer_to_server(server_name: String, id: int):
	#FIXME: check exists
	print("Peer ", id, " joins ", server_name)
	peers_server[id] = server_name
	RPC.get_fe_peer_signal_list.rpc_id(id)
	pass
	
	
func remove_peer_from_server(id: int):
	var srv_name = peers_server[id]
	var srv_sigs = srvs[srv_name]
	print("Peer ", id, " leaves ", srv_name)
	for ps in srv_sigs:
		srv_sigs[ps].erase(id)
	peers_server.erase(id)

#removes useless signals
func cleanup_signals(srver_name: String) -> bool: #true - need too update
	var result : bool = false
	var srv_sigs = srvs[srver_name]
	for s in srv_sigs:
		if srv_sigs[s].is_empty():
			srv_sigs.erase(s)
			result = true
	return result
	

func update_fe_peer_signal_list(sig_list: Array, id: int, op: int):
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
		
	var add = "nothing needed"
	if clean_need_update:
		add = "clean needed"
	if add_need_update:
		add += " add needed"
	print("Peer ", id, " updats signals: ", add)
	
func add_fe_peer_outgoing_signals(signals: Dictionary, id: int):
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
			
func send_server_list(id: int):
	#FIXME: available only!!
	print("Sending server list to ", id)
	RPC.send_server_list.rpc_id(id, srvs.keys())
