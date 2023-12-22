class_name LeftBar
extends LineMenuGroup

signal logout()
signal server_selected(server_name: String)

@export var server_template: PackedScene
@export var button_group: ButtonGroup

@onready var login_label: Label = %Login as Label
@onready var logout_button: Button = %"Log Out" as Button

@onready var server_container: Control = %Servers
@onready var server_line_menu: LineMenu = %"Servers Menu" as LineMenu

func _ready() -> void:
	super._ready()
	logout_button.pressed.connect(func(): logout.emit())

func set_person(person: Person) -> void:
	login_label.text = person.full_name

func add_server(server_name: String) -> void:
	var instance = server_template.instantiate() as ServerItem
	instance.server_name = server_name
	instance.set_button_group(button_group)
	instance.get_line_item().item_pressed.connect(func(item: LineItem): server_selected.emit(item.tag))
	server_line_menu.add_item(instance.get_line_item())
	#server_line_menu.menu_items.append(instance.get_line_item())
	server_container.add_child(instance)

func clear_servers() -> void:
	for child in server_container.get_children():
		child.free()
