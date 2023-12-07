class_name PersonsTable
extends Control

signal selected(row: PersonRow)
signal edited(row: PersonRow)
signal deleted(row: PersonRow)

@onready var container: Control = %Container
@export var person_row_prefab: PackedScene

var background_color: Color = Color(0.9372549019607843, 0.9490196078431373, 0.9568627450980392)

var rows: Array[PersonRow]

func _on_split_0_sort_children():
	for i in range(container.get_child_count()):
		var row : PersonRow = container.get_child(i)
		align_row(row)

func clear() -> void:
	for row in rows:
		row.free()
	rows.clear()

func add_array(persons: Array[Person]) -> void:
	for person in persons:
		add(person)

func add(person: Person) -> void:
	var person_row: PersonRow = person_row_prefab.instantiate() as PersonRow
	person_row.construct(person)
	subscribe_to_row_signals(person_row)
	rows.append(person_row)
	container.add_child(person_row)
	
	if container.get_child_count() % 2 == 0:
		person_row.paint_background(background_color)
	
	align_row(person_row)

func subscribe_to_row_signals(row: PersonRow) -> void:
	row.edited.connect(func(inner: PersonRow): edited.emit(inner))
	row.selected.connect(func(inner: PersonRow): selected.emit(inner))
	row.deleted.connect(func(inner: PersonRow): deleted.emit(inner))

func align_row(row: PersonRow) -> void:
	var iconColumn = $Container/HBoxContainer/Icon
	var nameColumn = $Container/HBoxContainer/Split0/Name
	var loginColumn = $Container/HBoxContainer/Split0/Split1/Login
	var roleColumn = $Container/HBoxContainer/Split0/Split1/Split2/Role
	row.align_column_width(iconColumn, nameColumn, loginColumn, roleColumn)
