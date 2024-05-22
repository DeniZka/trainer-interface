extends Node

@onready var crt = preload("res://certificates/X509_Certificate.crt")
@onready var key = preload("res://certificates/X509_Key.key")

@onready var peer : ENetMultiplayerPeer
var ui_update_timer: Timer

const SERV_LAN = "192.168.100.157:61613"
const LAN_LOGIN = "admin"
const LAN_PASS = "105Admin105"

const SERVER_PORT = 10508
const POLL_TIMEOUT = 0.05 #s
var AMQP_ADDRESS : String = SERV_LAN
const AMQP_HOST : String = "/"
var AMQP_LOGIN : String = LAN_LOGIN
var AMPQ_PASS : String = LAN_PASS
const HYPERVISOR_CHECK_TIMEOUT = 5.0

var is_sit_connected : bool = false

#for STOMP request
signal request_post_signals_into_server(server_name: String, signals: Dictionary)
#@onready var sit_manager : SITManager
var hypervisor: SITHypervisor
#var servers : Array[SITManager] = []
var models: Dictionary = {} #"name": base64
var models_servers : Dictionary = {} #"name": [server_name, ..]


var stomp : STOMPClient = null
var api_models : JSONApi

###main part---------------------------------------------------------------------------------
func _ready():
	AMQP_ADDRESS = GlobalConfig.get_amqp_url()
	AMQP_LOGIN = GlobalConfig.get_amqp_username()
	AMPQ_PASS = GlobalConfig.get_amqp_password()
	
	begin_serve()   #FIRST give clients passability to interact server
	_on_user_sit_connect(RPC.CONNECTION_TCP)  #SECOND connect to AMQP
	$UI_update.start(1.0) #interface view internal status
	api_models = Api.models as JSONApi
	var json = await api_models.all()
	print(json)
	

	
func _exit_tree():
	hypervisor.free()
	stomp.close()

var poll_timer = 0
func _process(delta):
	poll_timer += delta
	if poll_timer >= POLL_TIMEOUT:
		if stomp:
			stomp.poll()
		poll_timer = 0

func _on_ui_update_timeout():
	$users.text = JSON.stringify(hypervisor.get_peers(),"\t")
	$signals.text = JSON.stringify(hypervisor.get_servers_statistic(), "\t")
	$links.text = JSON.stringify(models_servers, "\t")
	
func begin_serve():
	peer = ENetMultiplayerPeer.new()
	#peer.inbound_buffer_size = 6553500
	#peer.outbound_buffer_size = 6553500
	#peer.create_server(SERVER_PORT, "*", TLSOptions.server(key, crt))
	peer.create_server(SERVER_PORT)
	
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	RPC.sit_connection_status_requested.connect(_on_user_sit_connection_status)
	RPC.sit_connection_requested.connect(_on_user_sit_connect)
	
	RPC.server_list_requested.connect(_on_user_server_list_requested)
	RPC.create_server_requested.connect(_on_user_server_create)
	RPC.kill_server_requested.connect(_on_user_kill_server)
	
	RPC.model_list_requested.connect(_on_user_model_list_requested)
	RPC.upload_model_requested.connect(_on_user_upload_model)
	
	#multiplayer.get_peers()
	#request_post_signals_into_server.connect(_ON_request_post_signals_into_server)
	
func _on_user_sit_connect(method: int):
	if is_sit_connected:
		RPC.sit_connection_status.rpc(is_sit_connected)
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
		
	hypervisor = SITHypervisor.new(stomp)
	hypervisor.hv_heartbeat_received.connect(_on_hypervisor_heartbeat)
	$Hypervisor_alive.start(HYPERVISOR_CHECK_TIMEOUT)
	
	#hypervisor.server_up("DUMMY")
	hypervisor.server_up_received.connect(_on_hypervisor_server_up)
	hypervisor.get_server_list(0)
	
signal connection_result(ok: bool) #one shot signal
func connect_to_server(stomp: STOMPClient, address: String, host: String, login: String, password: String):
	var error = stomp.connect_to_host(address)
	if error != OK: #FIXME: connection trouble
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

func _on_amqp_connect_check_timeout():
	Log.trace("Can't connect to AMQP") #TODO: 
	connection_result.emit(false)
	
#one shot callback function on connection if not delayed
func _on_connection_result(packet: STOMPPacket):
	$Connection_checker.stop()
	Log.trace("Сообщение от сервера RabbitMQ: %s" % packet.to_string())
	connection_result.emit(true)
	
#one shot timer STOMP connection
func _on_connection_checker_timeout():
	Log.debug("STOMP connection timeout")
	connection_result.emit(false)
	
func _on_user_sit_connection_status():
	#TODO: stomp.is_connected
	RPC.sit_connection_status.rpc(is_sit_connected)
	
#reset timer on heartbeat
func _on_hypervisor_heartbeat(_message: String):
	$Hypervisor.modulate = Color(0,1,0)
	$LHVStatus.text = "ON"
	$Hypervisor_alive.start(HYPERVISOR_CHECK_TIMEOUT)
	
func _on_hypervisor_alive_timeout():
	#TODO: clean????
	if not is_node_ready(): await ready
	$Hypervisor.modulate = Color(1,0,0)
	$LHVStatus.text = "OFF"
	RPC.hypervisor_down.rpc()
	#Log.trace("Warning! Hypervisor is not response")
	
func _on_hypervisor_server_up(server_name: String):
	hypervisor.get_server_list(0)
	for model in models_servers:
		if server_name in models_servers[model]:
			models_servers[model][server_name] = "UP"
			
func _on_hypervisor_server_down(server_name: String):
	hypervisor.get_server_list(0)
	for model in models_servers:
		if server_name in models_servers[model].keys():
			models_servers[model][server_name] = "DOWN"	
	
#func send_signals_anyone_at(srv: String, sigs: Dictionary):
	#for server in servers:
		#if server.name == srv:
			#server.update_signals(sigs)

#multiplayer callback
func _on_peer_connected(id: int):
	Log.trace("New frontend connected: %d" % id)
	hypervisor.peer_connected(id)
	#Log.trace("Peer count: %d" % pl.size())
	
func _on_peer_disconnected(id: int):
	Log.trace("Some frontend disconnected:  %d" % id)
	hypervisor.peer_disconnected(id)
	#Log.trace("Peer count: %d" % pl.size())	
	
func _on_user_server_list_requested(id: int):
	hypervisor.get_server_list(id)
	pass
	
func _on_user_server_create(server_name: String, model_name: String):
	#TODO: get model file
	hypervisor.create_server(server_name, models[model_name])
	models_servers[model_name].merge({server_name: "DOWN"})
	
func _on_user_kill_server(server_name: String):
	hypervisor.kill_server(server_name)
	for model in models_servers:
		if server_name in models_servers[model]:
			models_servers[model].erase(server_name)
			break
	
func _on_user_model_list_requested(id: int):
	RPC.send_model_list.rpc_id(id, models.keys())
	
func _on_user_upload_model(model_name: String, base64_file: String, id: int):
	models[model_name] = base64_file
	models_servers[model_name] = {}
	RPC.send_model_list.rpc_id(id, models.keys())
	
##testing loopback model react immitation
#func _ON_request_post_signals_into_server(srv: String, signals: Dictionary):
	#for k in signals:
		#if "_YB01" in k and signals[k][0] == true:
			#var stat = k.replace("_YB01", "_is_state")
			#send_signals_anyone_at(srv, {stat: [3]})
		#if "_YB02" in k and signals[k][0] == true:
			#var stat = k.replace("_YB02", "_is_state")
			#send_signals_anyone_at(srv, {stat: [5]})
	
func _on_button_pressed():
	#request
	_on_user_server_create($LEServerName.text, $OBModelList.get_item_text($OBModelList.selected))
	#response
	hypervisor.process_string(
		JSON.stringify(
			{"jsonrpc":"2.0", "method":"server_up","params":$LEServerName.text}
		)
	)
	#hypervisor.server_up($LineEdit.text)

func _on_button_2_pressed():
	#request
	_on_user_kill_server($LEServerName.text)
	#response
	hypervisor.server_down($LEServerName.text)

func _on_b_create_model_pressed():
	_on_user_upload_model($LEModelName.text, "hello world", 0)
	$OBModelList.clear()
	for model_name in models:
		$OBModelList.add_item(model_name)


func _on_server_list_timeout():
	pass # Replace with function body.


func _on_b_server_list_pressed():
	hypervisor.get_server_list(0)
	pass # Replace with function body.
