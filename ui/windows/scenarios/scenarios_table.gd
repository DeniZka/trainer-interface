class_name ScenariosTable
extends Control

@onready var container: Control = %Container
@export var scenario_row_prefab: PackedScene

var background_color: Color = Color(0.9372549019607843, 0.9490196078431373, 0.9568627450980392)

func add_scenario(scenario: ScenarioData) -> void:
	var scenario_row: ScenarioRow = scenario_row_prefab.instantiate() as ScenarioRow
	scenario_row.construct(scenario)
	container.add_child(scenario_row)
	
	if container.get_child_count() % 2 == 0:
		scenario_row.paint_background(background_color)
	
	align_row(scenario_row)

func align_row(row: ScenarioRow) -> void:
	var icon_column = $HBoxContainer/Icon
	var name_column = $HBoxContainer/Split0/Name
	var model_column = $HBoxContainer/Split0/Split1/Connected_model
	var author_column = $HBoxContainer/Split0/Split1/Split2/Author
	var upload_date_column = $HBoxContainer/Split0/Split1/Split2/Split3/Load_date
	row.align_column_width(icon_column, name_column, model_column, author_column, upload_date_column)
