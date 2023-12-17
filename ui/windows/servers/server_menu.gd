class_name ServerMenu
extends BaseMenu

@onready var name_edit: LineEdit = %"Name" as LineEdit
@onready var author_edit: LineEdit = %Author as LineEdit
@onready var upload_date_edit: LineEdit = %"Upload Date" as LineEdit
@onready var data_exchange_edit: LineEdit = %"Data Exchange" as LineEdit

func _on_save_button_pressed() -> void:
	pass

func _on_delete_button_pressed() -> void:
	deleted.emit(null)

func _on_close_button_pressed() -> void:
	closed.emit()
