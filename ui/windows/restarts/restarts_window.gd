class_name RestartsWindow
extends BaseWindow

func _on_initialize() -> void:
	api = Api.saves

func _on_update_data() -> void:
	var response: HTTPResponse = await api.all()
	var persons: Array[Save] = Save.create_from_response(response)
	table.clear()
	table.add_array(persons)

func _on_row_edited(row: RestartRow) -> void:
	opened_menu.emit(row.data)

func _on_row_deleted(row: RestartRow) -> void:
	var response = await api.delete(row.data.id)
