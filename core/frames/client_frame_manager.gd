extends Node

#FIXME: replace nodes frame managers with real client nodes
@onready var nodes = [$frame_manager, $frame_manager2]

var cli_signals : Dictionary = {}

@onready var peer : ENetMultiplayerPeer

# Called when the node enters the scene tree for the first time.
func _ready():
	peer = ENetMultiplayerPeer.new()

	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(con_failed)
	multiplayer.server_disconnected.connect(_on_disconnected)
	RPC.server_list_updated.connect(new_server_list)
	RPC.signal_list_requested.connect(send_signal_list)
	RPC.signals_values_received.connect(update_signal_values)
	RPC.server_join_granted.connect(_on_joined)
	$frame_manager.outgoing_signals_ready.connect(_on_signal_ready)
	
	#for n in nodes:
		#var fm: FrameManager
		#var node_sl : Array = n.get_request_signal_list()
		#for node_s in node_sl:
			#cli_signals

func _on_disconnected():
	print("disconnected")
	$frame_manager.visible = false

func _on_signal_ready():
	var sigs : Dictionary = $frame_manager.get_outgoing_signals()
	RPC.offer_signals_values.rpc(sigs)
	
func connected_to_server():
	print("Connnected")
	
func con_failed():
	print("failed")
	
func _on_joined():
	$frame_manager.visible = true

#dummy stuff
func _on_option_button_item_selected(index):
	for i in range(nodes.size()):
		if i == index:
			nodes[i].visible = true
		else:
			nodes[i].visible = false
	pass # Replace with function body.


func _on_connect_pressed():
	var err = peer.create_client("127.0.0.1", 10508)
	multiplayer.multiplayer_peer = peer
	var prs = multiplayer.get_peers()
	
	print(err)


func _on_srv_list_pressed():
	RPC.get_server_list.rpc()

func new_server_list(srvs: Array):
	print("Recevied servers: ", srvs)
	$node_control/join.text = srvs[0]


func _on_join_pressed():
	print("try to join")
	RPC.join_server.rpc($node_control/join.text)
	
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
	$frame_manager.visble = false
