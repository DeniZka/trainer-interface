class_name ModelsTable
extends Control

@onready var container: Control = %Container
@export var model_row_template: PackedScene

var background_color: Color = Color(0.9372549019607843, 0.9490196078431373, 0.9568627450980392)

func _on_split_0_sort_children():
	for i in range(container.get_child_count()):
		var row : ModelRow = container.get_child(i)
		align_row(row)

func add_model(model: ModelData) -> void:
	var model_row: ModelRow = model_row_template.instantiate() as ModelRow
	model_row.construct(model)
	container.add_child(model_row)
	
	if container.get_child_count() % 2 == 0:
		model_row.paint_background(background_color)
	
	align_row(model_row)

func align_row(row: ModelRow) -> void:
	var iconColumn = $HBoxContainer/Icon
	var nameColumn = $HBoxContainer/Split0/Name
	var checksumColumn = $HBoxContainer/Split0/Split1/Control_sum
	var authorColumn = $HBoxContainer/Split0/Split1/Split2/Author
	var dateColumn = $HBoxContainer/Split0/Split1/Split2/Split3/Load_date
	row.align_column_width(iconColumn, nameColumn, checksumColumn, authorColumn, dateColumn)
