class_name ScenariosWindow
extends BaseWindow

func _on_initialize() -> void:
	api = Api.scenarios

func _on_update_data() -> void:
	var response: HTTPResponse = await api.all()
	var scenarios: Array[Scenario] = Scenario.create_from_response(response)
	table.clear()
	table.add_array(scenarios)

func _on_row_edited(row: ScenarioRow) -> void:
	opened_menu.emit(row.data)

func _on_row_deleted(row: ScenarioRow) -> void:
	var response = await api.delete(row.data.id)
