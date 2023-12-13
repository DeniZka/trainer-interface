extends Node
#for everygone exchange

#signals for frontend
signal signals_values_received(signals: Dictionary)
signal signal_list_requested()
signal rights_updated(rights: Dictionary)
signal server_list_updated(servers: Array)
signal server_join_granted()

#signals for backend
signal server_list_requested(id: int)
signal join_server_requested(server_name: String, peer: int)
signal leave_server_requested(peer: int)
signal request_signal_list_updated(signal_list: Array, peer: int, operaion: int)
signal signal_values_offered(signals: Dictionary, peer: int)


#functions for FE and BE
enum {SLOP_UPDATE, SLOP_NEW, SLOP_CLEAR}


#FE functions.rpc()
@rpc("any_peer")
func update_request_signal_list(signal_list: Array, op: int = SLOP_UPDATE):
	request_signal_list_updated.emit(signal_list, multiplayer.get_remote_sender_id(), op)
	
@rpc("any_peer")
func offer_signals_values(signals: Dictionary):
	signal_values_offered.emit(signals, multiplayer.get_remote_sender_id())

@rpc("any_peer")
func get_server_list():
	server_list_requested.emit(multiplayer.get_remote_sender_id())

@rpc("any_peer")
func join_server(server_name: String):
	join_server_requested.emit(server_name, multiplayer.get_remote_sender_id())
	
@rpc("any_peer")
func leave_server():
	leave_server_requested.emit(multiplayer.get_remote_sender_id())

#BE functions.rpc()
@rpc
func set_fe_peer_signal_values(signals: Dictionary):
	signals_values_received.emit(signals)

@rpc
func get_fe_peer_signal_list():
	signal_list_requested.emit()
	
@rpc
func update_rights(rights: Dictionary):
	rights_updated.emit(rights)
	
@rpc  #close frames for user
func kick_peer():
	pass

@rpc
func server_shit_happens(shit_kind: int, shit_support: String):
	#client handle error happen on server
	print(shit_support)

@rpc
func send_server_list(servers: Array):
	server_list_updated.emit(servers)
	
@rpc
func grant_join_server():
	server_join_granted.emit()
