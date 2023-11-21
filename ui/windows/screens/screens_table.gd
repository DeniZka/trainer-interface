class_name ScreensTable
extends Control

@onready var container: Control = %Container
@export var screen_row_template: PackedScene

var background_color: Color = Color(0.9372549019607843, 0.9490196078431373, 0.9568627450980392)

func _on_split_0_sort_children():
	for i in range(container.get_child_count()):
		var row : ScreenRow = container.get_child(i)
		align_row(row)

func add_screen(screen: ScreenData) -> void:
	var screen_row: ScreenRow = screen_row_template.instantiate() as ScreenRow
	screen_row.construct(screen)
	container.add_child(screen_row)
	
	if container.get_child_count() % 2 == 0:
		screen_row.paint_background(background_color)
	
	align_row(screen_row)

func align_row(row: ScreenRow) -> void:
	var icon_column = $HBoxContainer/Icon
	var name_column = $HBoxContainer/Split0/Name
	var model_column = $HBoxContainer/Split0/Split1/Connected_model
	var allowed_roles_column = $HBoxContainer/Split0/Split1/Split2/Allowed_roles
	var allowed_users_column = $HBoxContainer/Split0/Split1/Split2/Split3/Allowed_users
	var author = $HBoxContainer/Split0/Split1/Split2/Split3/Split4/Author
	var date = $HBoxContainer/Split0/Split1/Split2/Split3/Split4/Split5/Load_date
	row.align_column_width(icon_column, name_column, model_column, allowed_roles_column, allowed_users_column, author, date)
