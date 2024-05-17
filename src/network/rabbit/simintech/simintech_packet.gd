class_name SimintechPacket
extends RefCounted

var transition_id: int
var commands: Array[SimintechCommand]

func _init(id: int, commands: Array[SimintechCommand] = []) -> void:
	transition_id = id
	self.commands = commands

func add_command(command: SimintechCommand) -> SimintechPacket:
	commands.append(command)
	return self

func serialize() -> Dictionary:
	var serialized_commands: Array[Dictionary]
	
	for command in commands:
		serialized_commands.append(command.serialize())
	
	return {
		"trans_id": transition_id,
		"commands": serialized_commands
	}

func to_json() -> String:
	return JSON.stringify(serialize(), "", false)

static func write_signals_to_db(id: int, signals: Dictionary) -> SimintechPacket:
	var write_command: WriteSignalsSimintechCommand = WriteSignalsSimintechCommand.new()
	write_command.signal_names = signals.keys()
	write_command.signal_values = signals.values()
	return SimintechPacket.new(id, [write_command])

static func read_signals_from_db(id: int, signal_names: Array[String]) -> SimintechPacket:
	var read_command: ReadSignalsSimintechCommand = ReadSignalsSimintechCommand.new()
	read_command.signals = signal_names
	return SimintechPacket.new(id, [read_command])
