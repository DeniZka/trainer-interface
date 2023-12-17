class_name ScreensWindow
extends BaseWindow

func _on_initialize() -> void:
	api = Api.screens

func _on_update_data() -> void:
	var response: HTTPResponse = await api.all()
	var persons: Array[Screen] = Screen.create_from_response(response)
	table.clear()
	table.add_array(persons)

func _on_row_edited(row: ScreenRow) -> void:
	opened_menu.emit(row.data)

func _on_row_deleted(row: ScreenRow) -> void:
	var response = await api.delete(row.data.id)
