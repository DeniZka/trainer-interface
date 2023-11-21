class_name ScenarioRow
extends Control

func align_column_width(icon_column: Control, name_column: Control, model_column: Control, 
		author_column: Control, upload_date_column: Control):
	$Buttons_and_icons.custom_minimum_size.x = icon_column.size.x
	$Split0/Name.custom_minimum_size.x = name_column.size.x
	$Split0/Split1/Connected_model.custom_minimum_size.x = model_column.size.x
	$Split0/Split1/Split2/Author.custom_minimum_size.x = author_column.size.x
	$Split0/Split1/Split2/Split3/Load_date.custom_minimum_size.x = upload_date_column.size.x

func construct(scenario: ScenarioData) -> void:
	%Id.set_text("ID: %s" % scenario.id)
	%Name.set_text(scenario.name)
	%"Connected Model".set_text(scenario.connected_model)
	%Author.set_text(scenario.author)
	%Icon.set_button_icon(load(scenario.icon_path))
	%"Upload Date".set_text(scenario.upload_at)

func paint_background(color: Color) -> void:
	%Background.color = color
