class_name ServerControlBar
extends Node

@onready var initialization_button: Button = %"Inizialization Button" as Button
@onready var play_button: Button = %"Play Button" as Button
@onready var step_button: Button = %"Step Button" as Button
@onready var pause_button: Button = %"Pause Button" as Button
@onready var stop_button: Button = %"Stop Button" as Button

var server_name: String

func _ready() -> void:
	initialization_button.pressed.connect(func(): _rpc_send_command(SITCommand.Init))
	play_button.pressed.connect(func(): _rpc_send_command(SITCommand.Play))
	step_button.pressed.connect(func(): _rpc_send_command(SITCommand.Step))
	pause_button.pressed.connect(func(): _rpc_send_command(SITCommand.Pause))
	stop_button.pressed.connect(func(): _rpc_send_command(SITCommand.Stop))

func _rpc_send_command(command: String) -> void:
	if server_name == "":
		return
	
	RPC.server_control.rpc(command, server_name)

func set_server(server_name: String) -> void:
	self.server_name = server_name

func clear() -> void:
	server_name = ""
