class_name MultiplayerFrames
extends Control

signal closed()
signal commands_prepared(data: Dictionary)

@onready var frame_manager: FrameManager = %"Frame Manager" as FrameManager

func open() -> void:
	frame_manager.visible = true
	frame_manager.exit_called.connect(_on_exit_called)

func close() -> void:
	frame_manager.exit_called.disconnect(_on_exit_called)	
	frame_manager.visible = false

func _on_exit_called() -> void:
	closed.emit()
