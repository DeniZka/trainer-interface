class_name ModelsWindow
extends BaseWindow

func _on_initialize() -> void:
	api = Api.models

func _on_update_data() -> void:
	var response: HTTPResponse = await api.all()
	var models: Array[Model] = Model.create_from_response(response)
	table.clear()
	table.add_array(models)

func _on_row_edited(row: ModelRow) -> void:
	opened_menu.emit(row.model)

func _on_row_deleted(row: ModelRow) -> void:
	var response = await api.delete(row.model.id)
