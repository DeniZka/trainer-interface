class_name AuthorizatedWindowsManager
extends Control

@onready var windows_manager: WindowsManager = %"Windows Manager" as WindowsManager
@onready var login_form: LoginForm = %"Login Form" as LoginForm
@onready var multiplayer_frames: MultiplayerFrames = %"Multiplayer Frames" as MultiplayerFrames
@onready var multiplayer_connection: MultiplayerConnection = %"Multiplayer Connection" as MultiplayerConnection

var authorized_person: Person

func _ready() -> void:
	login_form.authorized.connect(_on_person_authorized)
	multiplayer_frames.closed.connect(_on_multiplyaer_frames_closed)
	windows_manager.navigation_bar.logout.connect(_on_person_logout)
	windows_manager.server_requested.connect(_on_server_requested)
	windows_manager.server_selected.connect(_on_server_selected)
	RPC.server_list_updated.connect(_on_server_list_updated)
	RPC.server_join_granted.connect(_on_server_join_granted)
	RPC.server_join_rejected.connect(_on_server_join_refected)

func _on_person_authorized(person: Person) -> void:
	UserProfile.authenticate(person)
	authorized_person = person
	windows_manager.navigation_bar.set_person(person)
	multiplayer_connection.connect_to_server()
	var state: int = await multiplayer_connection.changed
	login_form.hide()
	RPC.get_server_list.rpc()

func _on_person_logout() -> void:
	login_form.show()
	multiplayer_connection.disconnect_from_server()

func _on_server_join_granted(user_list: Array) -> void:
	Log.info("Соединение с сервером успешно")
	windows_manager.hide()
	multiplayer_frames.open()

func _on_multiplyaer_frames_closed() -> void:
	Log.info("Отключение от общих экранов")
	RPC.leave_server.rpc()
	multiplayer_frames.close()
	windows_manager.show()

func _on_server_join_refected(reason: String) -> void:
	Log.info("Не удалось присоединиться к серверу. Причина: %s" % reason)
	login_form.show()

func _on_server_selected(server_name: String) -> void:
	RPC.join_server.rpc(server_name, authorized_person.login)

func _on_server_requested() -> void:
	RPC.get_server_list.rpc()

func _on_server_list_updated(servers: Array) -> void:
	windows_manager.update_servers(servers)
