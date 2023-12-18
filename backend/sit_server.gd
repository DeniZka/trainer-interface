class_name SITServer
extends SITTranciever

const EXCHANGE_TYPE = "/exchange/"
const SERVER_SEND_PATH : String      = EXCHANGE_TYPE + "server/"
const SERVER_SUBSCRIBE_PATH : String = EXCHANGE_TYPE + "godot/"

var name : String
var users : Dictionary = {}  #{ "id": {"name: name, "cursor": Vec2, "signals": [signals, ..] } }
var signals : Dictionary = {} #"signal_name": [userid0, userid1, ..]

# server interact signals
signal server_state_received(server_name: String)
signal update_signals_received(server_name: String, signals: Dictionary)

signal user_is_joined(server_name: String, id: int)
signal user_is_leaved(server_name: String, id: int)
enum{SRV_STATUS_UNAVAILABLE, SRV_STATUS_AVAILABLE}
var status := SRV_STATUS_UNAVAILABLE

#func set_destination
func _init(server_name: String, stomp: STOMPClient):
	super._init(SERVER_SEND_PATH + server_name, SERVER_SUBSCRIBE_PATH + server_name, stomp)
	self.name = server_name
	RPC.server_control_requested.connect(_on_user_server_control)
	RPC.join_server_requested.connect(_on_user_join_server_requested)
	RPC.leave_server_requested.connect(_on_user_leave_server_requested)
	RPC.request_signal_list_updated.connect(_on_user_request_signal_list_updated)
	RPC.signal_values_offered.connect(_on_user_signal_values_offered)
	RPC.cursor_position_updated.connect(_on_user_cursor)
	
func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		drop_users()
		
func get_statistics() -> Array:
	var unames : Array = []
	for u in users:
		unames.append(users[u]["name"])
	return [unames, signals.keys()]
	
func drop_users():
	for uid in users:
		RPC.kick_peer.rpc_id(uid, "Server is down")
	RPC.server_unavailable.rpc(self.name)
	
#available: play, stop, pause, step, init
func server_control(action: String):
	var packet: String = JSON.stringify(make_request("server_control", action, 0))
	send( STOMPPacket.to(send_path).with_message(packet) )
	
func set_signal_list():
	var packet: String = JSON.stringify(make_request("set_signal_list", signals, 0))
	send( STOMPPacket.to(send_path).with_message(packet) )
	
func set_signals(signals: Dictionary):
	var packet: String = JSON.stringify(make_request("set_signals", signals, 0))
	send( STOMPPacket.to(send_path).with_message(packet) )


##JSON_CALLBACKS
##server responses
func server_state(state: Array):
	RPC.server_status.rpc(self.name, state)
	server_state_received.emit(self.name, state)

func update_signals(signals: Dictionary):
	for id in users.keys():
		RPC.set_signal_values.rpc_id(id, signals)
	update_signals_received.emit(self.name, signals)
	

##USERS_CALLBACKS
func _on_user_join_server_requested(server_name: String, user_name: String, id: int):
	#Check already connected
	if self.name == server_name and id in users:
		RPC.reject_join_server.rpc_id(id, "Already on server")
	#TODO: Check user ID access rights
	var already_users = []
	for uid in users:
		already_users.append(users[uid]["name"])
		RPC.user_joined.rpc_id(uid, user_name) #inform already users new join
	RPC.grant_join_server.rpc_id(id, already_users)
	users[id] = {
		"name": user_name,
		"signals" : [],
		"cursor" : Vector2.ZERO
	}
	Log.trace("User %s joins %s" % [user_name, self.name])
	user_is_joined.emit(self.name, id)
	#request signal list
	RPC.get_signals_list.rpc_id(id)  #FIXME:   fix it <-----------------------
	
func user_is_suddenly_disconnected(id: int):
	_on_user_leave_server_requested(id)
	
func _on_user_leave_server_requested(id: int):
	if not id in users:
		return
	var leaving_user = users[id]["name"]
	for uid in users:
		RPC.user_leaved.rpc_id(uid, leaving_user)
	users.erase(id)
	for ps in signals: #cleanup id from every sig_info
		signals[ps].erase(id) #remove if was applied
	cleanup_signals()
	user_is_leaved.emit(self.name, id)
	Log.trace("User %s leave %s" % [leaving_user, self.name] )
	
#removes useless signals
func cleanup_signals() -> bool: #true - need too update
	var result : bool = false
	var keys = signals.keys() #for clean clearing
	for k in keys:
		if signals[k].is_empty():
			signals.erase(k)
			result = true
	return result

func _on_user_request_signal_list_updated(sig_list: Array, id: int, _op: int):
	if not id in users:
		return
	users[id]["signals"] = sig_list
	#add new owner of signal
	var update_due_added = false
	var update_due_clean = false
	for ps in signals: #cleanup id from every sig_info
		signals[ps].erase(id) #remove if was applied
	for sig in sig_list:
		if sig in signals:
			signals[sig].append(id)
		else:
			signals[sig] = [id]
			update_due_added = true
			
	update_due_clean = cleanup_signals()
	if update_due_added or update_due_clean:
		set_signal_list()
		
	var add = ""
	if update_due_clean:
		add = " cleaned unwanted"
	if update_due_added:
		add += " added new"
	if add == "":
		add = "nothing needed"
	Log.trace("User %s updates signals on %s" % [users[id]["name"], self.name])
			
	
func _on_user_signal_values_offered(signals: Dictionary, id: int):
	if not id in users:
		return
	set_signals(signals)
	Log.trace("User %s wants to do something nasty on %s " % [users[id]["name"], self.name])
	#request_post_signals_into_server.emit(srv_name, signals)     #FIXME: local loop
	
func _on_user_cursor(pos: Vector2, id: int):
	if not id in users:
		return
	users[id]["cursor"] = pos
	for uid in users:
		if uid != id: #for all on the same server
			RPC.user_status.rpc_id(uid, users[id]["name"], pos)

func _on_user_server_control(server_name: String, action: String):
	server_control(action)
