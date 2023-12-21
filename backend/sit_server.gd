class_name SITServer
extends SITTranciever

const EXCHANGE_TYPE = "/exchange/"
const SERVER_SEND_PATH : String      = EXCHANGE_TYPE + "server/"
const SERVER_SUBSCRIBE_PATH : String = EXCHANGE_TYPE + "godot/"

var name : String
var users : Dictionary = {}  #{ "id": {"name: name, "cursor": Vec2, "signals": [signals, ..] } }
var signals : Dictionary = {} #"signal_name": [userid0, userid1, ..]

# server interact signals
signal server_state_received(server_name: String, state: Dictionary)
signal update_signals_received(server_name: String, signals: Dictionary)

enum{SRV_STATUS_UNAVAILABLE, SRV_STATUS_AVAILABLE}
var status := SRV_STATUS_UNAVAILABLE

#func set_destination
func _init(server_name: String, stomp: STOMPClient):
	super._init(SERVER_SEND_PATH + server_name, SERVER_SUBSCRIBE_PATH + server_name, stomp)
	self.name = server_name
	
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
	
func join_user(user_name: String, id: int) -> String: #reason
	#TODO: Check user ID access rights
		#return "No rigths to join"
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
	#request signal list
	RPC.get_signals_list.rpc_id(id)  #FIXME:   fix it <-----------------------
	return ""
	
func leave_user(id: int) -> bool:
	var leaving_user = users[id]["name"]
	for uid in users:
		RPC.user_leaved.rpc_id(uid, leaving_user)
	users.erase(id)
	for ps in signals: #cleanup id from every sig_info
		signals[ps].erase(id) #remove if was applied
	cleanup_signals()
	Log.trace("User %s leave %s" % [leaving_user, self.name] )
	return true
	

	
##JSON_CALLBACKS
##server responses
func server_state(state: Dictionary):
	print(state)
	for id in users.keys():
		RPC.server_status.rpc_id(id, self.name, state)
	#RPC.server_status.rpc(self.name, state)
	server_state_received.emit(self.name, state)

func update_signals(signals: Dictionary):
	for id in users.keys():
		RPC.set_signal_values.rpc_id(id, signals)
	update_signals_received.emit(self.name, signals)
	
##USERS_CALLBACKS
#removes useless signals
func cleanup_signals() -> bool: #true - need too update
	var result : bool = false
	var keys = signals.keys() #for clean clearing
	for k in keys:
		if signals[k].is_empty():
			signals.erase(k)
			result = true
	return result

func user_signal_list(sig_list: Array, id: int, _op: int):
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
		var packet: String = JSON.stringify(make_request("set_signal_list", signals.keys(), 0))
		send( STOMPPacket.to(send_path).with_message(packet) )
		
	var add = ""
	if update_due_clean:
		add = " cleaned unwanted"
	if update_due_added:
		add += " added new"
	if add == "":
		add = "nothing needed"
	Log.trace("User %s updates signals on %s" % [users[id]["name"], self.name])
			
	
func user_signal_values(signals: Dictionary, id: int):
	var packet: String = JSON.stringify(make_request("set_signals", signals, 0))
	send( STOMPPacket.to(send_path).with_message(packet) )
	Log.trace("User %s wants to do something nasty on %s " % [users[id]["name"], self.name])
	#request_post_signals_into_server.emit(srv_name, signals)     #FIXME: local loop
	
func cursor_updated(pos: Vector2, id: int):
	users[id]["cursor"] = pos
	for uid in users:
		if uid != id: #for all on the same server
			RPC.user_status.rpc_id(uid, users[id]["name"], pos)

#available: play, stop, pause, step, init
func server_control(action: String):
	var packet: String = JSON.stringify(make_request("server_control", [action], 0))
	send( STOMPPacket.to(send_path).with_message(packet) )
