class_name PersonsWindow
extends BaseWindow

func _on_initialize() -> void:
	api = Api.persons

func _on_update_data() -> void:
	var response: HTTPResponse = await api.all()
	var persons: Array[Person] = Person.create_from_response(response)
	table.clear()
	table.add_array(persons)
	Log.debug("Обновил отображение пользователей в таблице")

func _on_row_edited(row: PersonRow) -> void:
	opened_menu.emit(row.person)

func _on_row_deleted(row: PersonRow) -> void:
	var response = await api.delete(row.person.id)
