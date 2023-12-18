class_name ServersWindow
extends BaseWindow

func _on_initialize() -> void:
	api = Api.servers

func _on_update_data() -> void:
	var response: HTTPResponse = await api.all()
	var servers: Array[Server] = Server.create_from_response(response)
	table.clear()
	table.add_array(servers)

func _on_row_edited(row: ServerRow) -> void:
	opened_menu.emit(row.data)

func _on_row_deleted(row: ServerRow) -> void:
	var response = await api.delete(row.data.id)
