class_name RoleMenu
extends BaseMenu

@onready var rolename_edit: LineEdit = %Rolename as LineEdit

func _on_ready() -> void:
	api = Api.roles

func _on_update_view(data: PersonRole) -> void:
	if data != null:
		rolename_edit.text = data.name
	else:
		rolename_edit.text = ""

func _create_from_menu() -> PersonRole:
	var role: PersonRole = PersonRole.new()
	role.name = rolename_edit.text
	return role
