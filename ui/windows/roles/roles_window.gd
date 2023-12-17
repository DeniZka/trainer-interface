class_name RolesWindow
extends BaseWindow

func _on_initialize() -> void:
	api = Api.roles

func _on_update_data() -> void:
	var response: HTTPResponse = await api.all()
	var roles: Array[PersonRole] = PersonRole.create_from_response(response)
	table.clear()
	table.add_array(roles)

func _on_row_edited(row: RoleRow) -> void:
	opened_menu.emit(row.role)

func _on_row_deleted(row: RoleRow) -> void:
	var response = await api.delete(row.role.id)
