class_name MultiplayerFrames
extends Control

@onready var frame_manager: FrameManager = %"Frame Manager" as FrameManager

func open() -> void:
	frame_manager.visible = true
	pass
