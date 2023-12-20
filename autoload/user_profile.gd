extends Node

signal updated()

var person: Person

func authenticate(person: Person) -> void:
	self.person = person
	updated.emit()

func has_admin_role() -> bool:
	if person == null || person.roles == null:
		return false
	
	for role in person.roles:
		if role.name == "Администратор":
			return true
	
	return false
		

func update_permissions() -> void:
	updated.emit()
