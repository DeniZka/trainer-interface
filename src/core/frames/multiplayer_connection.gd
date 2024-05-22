class_name MultiplayerConnection
extends Node

signal changed(new_state: int)

@onready var crt = preload("res://certificates/X509_Certificate.crt")
@onready var key = preload("res://certificates/X509_Key.key")

var backend_ip: String
var backend_port: int

var peer: ENetMultiplayerPeer

var state: ConnectionState = ConnectionState.Unknown :
	set(value):
		state = value
		changed.emit(value)

enum ConnectionState {
	Unknown = 0,
	Connected = 1,
	Failed = 2,
	Disconnected = 3
}

func _ready() -> void:
	backend_ip = GlobalConfig.get_backend_ip()
	backend_port = GlobalConfig.get_backend_port()
	
	peer = ENetMultiplayerPeer.new()
	#peer.inbound_buffer_size = 6553500
	#peer.outbound_buffer_size = 6553500
	multiplayer.connected_to_server.connect(_on_server_connected)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func get_server_websocket_url() -> String:
	return "wss://%s:%s" % [backend_ip, backend_port]

func _on_server_connected() -> void:
	Log.debug("Соединение установлено с %s" % get_server_websocket_url())
	state = ConnectionState.Connected

func _on_connection_failed() -> void:
	Log.error("Ошибка соединения! %s" % get_server_websocket_url())
	state = ConnectionState.Failed

func _on_server_disconnected() -> void:
	Log.debug("Отключение от %s" % get_server_websocket_url())
	state = ConnectionState.Disconnected

func connect_to_server() -> void:
	#var server_ip: String = get_server_websocket_url()
	#var error: int = peer.create_client(server_ip, TLSOptions.client(crt))
	var error: int = peer.create_client(backend_ip, backend_port)
	#Log.debug("Подключаюсь к серверу %s" % server_ip)
	if error != OK:
		Log.error("Не удалось подключиться к серверу. Код ошибки: %s" % error)
	multiplayer.multiplayer_peer = peer

func disconnect_from_server() -> void:
	Log.debug("Отключаюсь от сервера %s" % get_server_websocket_url())
	state = ConnectionState.Disconnected
	peer.close()
