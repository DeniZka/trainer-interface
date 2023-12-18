class_name LeftBar
extends LineMenuGroup

@export var server_template: PackedScene
@onready var server_container: Control = %Servers
@onready var server_line_menu: LineMenu = %"Servers Menu" as LineMenu

func add_server(server_name: String) -> void:
	var instance = server_template.instantiate() as ServerItem
	instance.server_name = server_name
	server_line_menu.add_item(instance.get_line_item())
	server_line_menu.menu_items.append(instance.get_line_item())
	server_container.add_child(instance)

func clear_servers() -> void:
	for child in server_container.get_children():
		child.free()
	server_line_menu.erase_nulls()
