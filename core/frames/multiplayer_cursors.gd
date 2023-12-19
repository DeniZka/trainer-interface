class_name MultiplayerCursors
extends Control

@onready var cursor_template = preload("res://core/frames/cursor.tscn")
@onready var container = $Container

var cursors: Array[UserCursor]

func _ready() -> void:
	RPC.server_join_granted.connect(_on_server_joined)
	RPC.user_joined_anounced.connect(_on_user_joined)
	RPC.user_leaved_anounced.connect(_on_user_leaved)
	RPC.users_status_updated.connect(_on_updated)

func _on_server_joined(users: Array) -> void:
	Log.debug("Подключился к серверу, пользователи: %s" % users)
	for user in users:
		_create_cursor(user)

func _on_user_joined(user_name: String) -> void:
	Log.debug("Пользователь %s подключился" % user_name)
	_create_cursor(user_name)

func _create_cursor(username: String) -> UserCursor:
	var cursor : UserCursor = cursor_template.instantiate()
	cursor.user = username
	container.add_child(cursor)
	cursors.append(cursor)
	return cursor

func _on_user_leaved(user_name: String) -> void:
	Log.debug("Пользователь %s отключился" % user_name)
	var cursor: UserCursor = null
	for i in cursors.size():
		if cursors[i].user == user_name:
			cursor = cursors[i]
			break
	
	if cursor:
		cursors.erase(cursor)
		cursor.queue_free()

func _on_updated(user_name: String, pos: Vector2) -> void:
	Log.trace("Обновление позиции курсора для %s (%s)" % [user_name, pos])
	for cursor in cursors:
		if cursor.user == user_name:
			cursor.update_cursor(pos)

func _on_cursor_send_timeout():
	RPC.cursor_position.rpc(get_viewport().get_mouse_position())
