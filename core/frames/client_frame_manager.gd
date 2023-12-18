extends Node

const NAMES_PARTS = ["va", "bla", "do", "hu", "tai", "chu", "pe", "gi"]

#FIXME: replace nodes frame managers with real client nodes
@onready var nodes = [$frame_manager, $frame_manager2]
var cursors : Array[UserCursor] = []

var cli_signals : Dictionary = {}

@onready var peer : ENetMultiplayerPeer

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_username()
	
	peer = ENetMultiplayerPeer.new()

	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(con_failed)
	multiplayer.server_disconnected.connect(_on_disconnected)
	RPC.server_list_updated.connect(new_server_list)
	RPC.signal_list_requested.connect(send_signal_list)
	RPC.signals_values_received.connect(update_signal_values)
	RPC.server_join_granted.connect(_on_joined)
	RPC.server_join_rejected.connect(_on_rejected)
	RPC.user_joined_anounced.connect(_on_user_joined)
	RPC.user_leaved_anounced.connect(_on_user_leaved)
	RPC.users_status_updated.connect(_on_cursor_updated)
	$frame_manager.outgoing_signals_ready.connect(_on_signal_ready)
	
	#for n in nodes:
		#var fm: FrameManager
		#var node_sl : Array = n.get_request_signal_list()
		#for node_s in node_sl:
			#cli_signals
func randomize_username():
	var name : String = ""
	randomize()
	for i in range(4):
		name = name + NAMES_PARTS[randi() % NAMES_PARTS.size()]
	$node_control/Username.text = name

func _on_disconnected():
	print("disconnected")
	$node_control/login_buttons.visible = false
	$frame_manager.visible = false

func _on_signal_ready():
	var sigs : Dictionary = $frame_manager.get_outgoing_signals()
	RPC.offer_signals_values.rpc(sigs)
	
func connected_to_server():
	$node_control/login_buttons.visible = true
	print("Connnected")
	
func con_failed():
	print("failed")
	
func _on_joined(user_list: Array):
	for user in user_list:
		Log.trace("On sever: %s" % user)
		var cur : UserCursor = load("res://core/frames/cursor.tscn").instantiate()
		$node_control.add_child(cur)
		cur.user = user
		cursors.append(cur)
	$frame_manager.visible = true
	$node_control/login_buttons/join.visible = false
	$node_control/login_buttons/leave.visible = true
	
func _on_rejected(reason: String):
	Log.trace("Join was rejected caouse of: %s" % reason)
	
func _on_user_joined(user_name : String):
	Log.trace("Jointed: %s" % user_name)
	var cur : UserCursor = load("res://core/frames/cursor.tscn").instantiate()
	$node_control.add_child(cur)
	cur.user = user_name
	cursors.append(cur)

func _on_user_leaved(user_name: String):
	Log.trace("Leaved: %s" % user_name)
	var cur : UserCursor = null
	for i in range(cursors.size()):
		if cursors[i].user == user_name:
			cur = cursors[i]
			break
	if cur : 
		cursors.erase(cur)
		cur.queue_free()
			

func _on_connect_pressed():
	var err = peer.create_client("127.0.0.1", 10508)
	multiplayer.multiplayer_peer = peer
	var prs = multiplayer.get_peers()
	
	print(err)


func _on_srv_list_pressed():
	RPC.get_server_list.rpc()
	$node_control/login_buttons/join.visible = true
	$node_control/login_buttons/leave.visible = false

func new_server_list(srvs: Array):
	print("Recevied servers: ", srvs)
	if srvs.size() > 0:
		$node_control/login_buttons/join.text = srvs[0]


func _on_join_pressed():
	print("try to join")
	RPC.join_server.rpc($node_control/login_buttons/join.text, $node_control/Username.text)
	
func send_signal_list():
	#get node signal list from frame managers
	var sl = $frame_manager.get_request_signal_list() 
	#send signal list for nodes
	RPC.update_request_signal_list.rpc(sl)
	
func update_signal_values(signals: Dictionary):
	$frame_manager.set_signal_values(signals)

func _on_disconnect_pressed():
	peer.close()

func _on_leave_pressed():
	RPC.leave_server.rpc()
	$frame_manager.visible = false
	$node_control/login_buttons/join.visible = true
	$node_control/login_buttons/leave.visible = false

func _on_cursor_send_timeout():
	RPC.cursor_position.rpc(get_viewport().get_mouse_position())
	pass # Replace with function body.
	
func _on_cursor_updated(user_name: String, pos: Vector2):
	for cur in cursors:
		if cur.user == user_name:
			cur.update_cursor(pos)
	#$Cursor.update_cursor(user_name, pos)


func _on_connection_timer_timeout():
	if multiplayer.get_peers().is_empty(): #connected
		$node_control/Connect.visible = true
		$node_control/disconnect.visible = false
		$node_control/login_buttons.visible = false
		$node_control/login_buttons/join.visible = true
		$node_control/login_buttons/leave.visible = false
	else:
		$node_control/login_buttons.visible = true
		$node_control/Connect.visible = false
		$node_control/disconnect.visible = true
		
