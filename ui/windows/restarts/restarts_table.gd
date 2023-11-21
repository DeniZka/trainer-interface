class_name RestartsTable
extends Control

@onready var container: Control = %Container
@export var restart_row_template: PackedScene

var background_color: Color = Color(0.9372549019607843, 0.9490196078431373, 0.9568627450980392)

func _on_split_0_sort_children():
	for i in range(container.get_child_count()):
		var row : RestartRow = container.get_child(i)
		align_row(row)

func add_restart(role: RestartData) -> void:
	var restart_row: RestartRow = restart_row_template.instantiate() as RestartRow
	restart_row.construct(role)
	container.add_child(restart_row)
	
	if container.get_child_count() % 2 == 0:
		restart_row.paint_background(background_color)
	
	align_row(restart_row)

func align_row(row: RestartRow) -> void:
	var iconColumn = $HBoxContainer/Icon
	var nameColumn = $HBoxContainer/Split0/Name
	var modelColumn = $HBoxContainer/Split0/Split1/Connected_model
	var authorColumn = $HBoxContainer/Split0/Split1/Split2/Author
	var dateColumnt = $HBoxContainer/Split0/Split1/Split2/Split3/Load_date
	row.align_column_width(iconColumn, nameColumn, modelColumn, authorColumn, dateColumnt)
