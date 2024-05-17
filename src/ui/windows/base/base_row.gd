class_name BaseRow
extends Control

signal selected(row: BaseRow)
signal edited(row: BaseRow)
signal deleted(row: BaseRow)

@onready var row_control_buttons: RowControlButtons = %"Row Control Buttons" as RowControlButtons

func _ready() -> void:
	row_control_buttons.selected.connect(func(): selected.emit(self))
	row_control_buttons.edited.connect(func(): edited.emit(self))
	row_control_buttons.deleted.connect(func(): deleted.emit(self))
