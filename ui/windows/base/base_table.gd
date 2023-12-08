class_name BaseTable
extends Control

signal selected(row: BaseRow)
signal edited(row: BaseRow)
signal deleted(row: BaseRow)

@onready var container: Control = %Container
@export var row_prefab: PackedScene

var background_color: Color = Color(0.9372549019607843, 0.9490196078431373, 0.9568627450980392)

var rows: Array

func clear() -> void:
	for row in rows:
		row.free()
	rows.clear()

func add_array(roles: Array) -> void:
	for role in roles:
		var row = add(role)
		align_row(row)

func align_row(row) -> void:
	pass

func add(data: Variant) -> Variant:
	var row: BaseRow = row_prefab.instantiate() as BaseRow
	row.construct(data)
	subscribe_to_row_signals(row)
	rows.append(row)
	container.add_child(row)
	
	if container.get_child_count() % 2 == 0:
		row.paint_background(background_color)
	return row

func subscribe_to_row_signals(row: BaseRow) -> void:
	row.edited.connect(func(inner: BaseRow): edited.emit(inner))
	row.selected.connect(func(inner: BaseRow): selected.emit(inner))
	row.deleted.connect(func(inner: BaseRow): deleted.emit(inner))
