class_name PersonRow
extends Control

signal selected(row: PersonRow)
signal edited(row: PersonRow)
signal deleted(row: PersonRow)

@onready var row_control_buttons: RowControlButtons = %"Row Control Buttons" as RowControlButtons

var person: Person

func _ready() -> void:
	row_control_buttons.selected.connect(func(): selected.emit(self))
	row_control_buttons.edited.connect(func(): edited.emit(self))
	row_control_buttons.deleted.connect(func(): deleted.emit(self))

func align_column_width(iconColumn: Control, nameColumn: Control, loginColumn: Control, roleColumn: Control):
	var col1: Control = $Buttons_and_icons
	var col2: Control = $Split0/Name
	var col3: Control = $Split0/Split1/Login
	var col4: Control = $Split0/Split1/Split2/Role
	col1.custom_minimum_size.x = iconColumn.size.x 
	col2.custom_minimum_size.x = nameColumn.size.x
	col3.custom_minimum_size.x = loginColumn.size.x
	col4.custom_minimum_size.x = roleColumn.size.x

func construct(person: Person) -> void:
	self.person = person
	%Id.set_text("ID: %s" % person.id)
	%Name.set_text(person.full_name)
	%Login.set_text(person.login)
	%Role.set_text(person.roles_to_string())
	#%Icon.set_button_icon(load(person.icon))

func paint_background(color: Color) -> void:
	%Background.color = color
