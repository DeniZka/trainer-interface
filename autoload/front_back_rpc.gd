extends Node
#for everygone exchange

#signals for frontend
signal signals_values_received(signals: Dictionary)
signal signal_list_requested()
signal rights_updated(rights: Dictionary)
signal server_list_updated(servers: Array)
signal server_join_granted(users_names: Array)
signal server_join_rejected(reason: String)
signal sit_connection_status_received(status)
signal kick_requested(reaseon: String) #kick target player when server is down. Require leave_server()
signal hypervisor_down_anounced()
signal server_creation_anounced(server_name: String)
signal server_down_anounced(server_name: String) #when server is realy down
signal server_unavailable_anounced(server_name: String) #before server is down
signal server_status_anounced(server_name: String, status: Array)
signal users_status_updated(user_name: String, pos: Vector2) #on the same server user joined {"Name": cursor }
signal user_joined_anounced(user_name: String)
signal user_leaved_anounced(user_name : String)
signal model_list_received(models: Array)


#signals for backend
signal server_list_requested(id: int)
signal join_server_requested(server_name: String, user_name: String,  peer: int)
signal leave_server_requested(peer: int)
signal request_signal_list_updated(signal_list: Array, peer: int, operaion: int)
signal signal_values_offered(signals: Dictionary, peer: int)
signal cursor_position_updated(pos: Vector2, peer: int)

signal create_server_requested(server_name: String, model_name: String)
signal kill_server_requested(server_name: String)
signal server_control_requested(server_name: String, action: String)
signal sit_connection_requested(method: int)
signal sit_connection_status_requested()
signal upload_model_requested(model_name: String, base64_file: String)
signal model_list_requested()

#functions for FE and BE
enum {SLOP_UPDATE, SLOP_NEW, SLOP_CLEAR}

#FE functions.rpc()
#player functions
@rpc("any_peer")
func get_server_list():
	server_list_requested.emit(multiplayer.get_remote_sender_id())

@rpc("any_peer")
func join_server(server_name: String, user_name: String):
	join_server_requested.emit(server_name, user_name, multiplayer.get_remote_sender_id())
	
@rpc("any_peer")
func leave_server():
	leave_server_requested.emit(multiplayer.get_remote_sender_id())

@rpc("any_peer")
func update_request_signal_list(signal_list: Array, op: int = SLOP_UPDATE):
	request_signal_list_updated.emit(signal_list, multiplayer.get_remote_sender_id(), op)
	
@rpc("any_peer")
func offer_signals_values(signals: Dictionary):
	signal_values_offered.emit(signals, multiplayer.get_remote_sender_id())
	
@rpc("any_peer")
func cursor_position(pos: Vector2):
	cursor_position_updated.emit(pos, multiplayer.get_remote_sender_id())

#Odmin functions
	
@rpc("any_peer")
func crete_server(server_name: String, model_name: String):
	create_server_requested.emit(server_name, model_name)

@rpc("any_peer")
func kill_server(server_name: String):
	kill_server_requested.emit(server_name)
	
@rpc("any_peer")
func server_control(server_name: String, action: String):
	server_control_requested.emit(server_name, action)
	
enum{CONNECTION_TCP, CONNECTION_WEB}
@rpc("any_peer")
func sit_connect(method: int):
	sit_connection_requested.emit()
	
@rpc("any_peer")
func get_sit_connection_status():
	sit_connection_status_requested.emit()
	
@rpc("any_peer")
func upload_model(model_name: String, base64_file: String):
	upload_model_requested.emit(model_name, base64_file, multiplayer.get_remote_sender_id())

@rpc("any_peer")
func get_model_list():
	model_list_requested.emit(multiplayer.get_remote_sender_id())
	


#BE functions.rpc()
@rpc
func set_signal_values(signals: Dictionary):
	signals_values_received.emit(signals)

@rpc
func get_signals_list():
	signal_list_requested.emit()
	
@rpc
func update_rights(rights: Dictionary):
	rights_updated.emit(rights)
	
@rpc  #close frames for user
func kick_peer(reason: String):
	kick_requested.emit(reason)

@rpc
func server_shit_happens(shit_kind: int, shit_support: String):
	#client handle error happen on server
	Log.trace(shit_support + " " + str(shit_kind))

@rpc
func send_server_list(servers: Array):
	server_list_updated.emit(servers)
	
@rpc
func grant_join_server(users_online: Array):
	server_join_granted.emit(users_online)
	
@rpc
func reject_join_server(reason: String):
	server_join_rejected.emit(reason)
	
@rpc
func sit_connection_status(status: bool):
	sit_connection_status_received.emit(status)
	
@rpc
func hypervisor_down():
	hypervisor_down_anounced.emit()
	
@rpc
func server_created(server_name: String):
	server_creation_anounced.emit(server_name)
	
@rpc
func server_killed(server_name: String):
	server_down_anounced.emit(server_name)
	
@rpc
func server_unavailable(server_name: String):
	server_unavailable_anounced.emit(server_name)
	
@rpc
func server_status(server_name: String, status: Array):
	server_status_anounced.emit(server_name, status)
	
@rpc
func user_status(user_name: String, pos: Vector2):
	users_status_updated.emit(user_name, pos)
	
@rpc
func user_joined(user_name: String):
	user_joined_anounced.emit(user_name)
	
@rpc
func user_leaved(user_name: String):
	user_leaved_anounced.emit(user_name)

@rpc
func send_model_list(models: Array):
	model_list_received.emit(models)
