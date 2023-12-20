class_name MultiplayerFrames
extends Control

signal closed()
signal commands_prepared(data: Dictionary)

@onready var frame_manager: FrameManager = %"Frame Manager" as FrameManager

func open() -> void:
	frame_manager.visible = true
	frame_manager.exit_called.connect(_on_exit_called)
	var signals: Array = frame_manager.get_request_signal_list()
	
	RPC.update_request_signal_list.rpc(signals)
	RPC.signals_values_received.connect(_on_update_signal_values)
	frame_manager.outgoing_signals_ready.connect(_on_outgoing_signals_ready)
	#frame_manager.commands_prepared.connect(_on_commands_prepared)

func drop_signals(signal_names: Array) -> void:
	var dropped_names: Array[String]
	for signal_name in signal_names:
		var line: String = signal_name as String
		if line.contains("XXX"):
			dropped_names.append(signal_name)

func close() -> void:
	frame_manager.exit_called.disconnect(_on_exit_called)
	RPC.signals_values_received.disconnect(_on_update_signal_values)
	frame_manager.commands_prepared.disconnect(_on_commands_prepared)
	frame_manager.visible = false

func _on_outgoing_signals_ready() -> void:
	var signals = frame_manager.get_outgoing_signals()
	_on_commands_prepared(signals)

func _on_commands_prepared(signals: Dictionary) -> void:
	Log.trace("Подготовленные команды: %s" % signals)
	RPC.offer_signals_values.rpc(signals)

func _on_update_signal_values(signals: Dictionary) -> void:
	frame_manager.set_signal_values(signals)

func _on_exit_called() -> void:
	closed.emit()
