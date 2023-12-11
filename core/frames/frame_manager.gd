class_name FrameManager
extends Node2D

signal exit_called() #emit when user wants to exit system
signal commands_prepared(signals: Dictionary)

@onready var nframes = $frames
@onready var dummy = $dummy_frame

func _ready():
	load_frames(["res://core/frames/KBA1.tscn", "res://core/frames/KBA2.tscn"])
		
var _silent: bool = false
#silent does not emit every single update for 
func load_frames(frames: Array, silent: bool = true) -> bool:
	var _s_bak = _silent #backup silent mode
	_silent = silent
	#TODO: cleanup actual frames
	for frame in nframes.get_children():
		#FIXME: disconnect???
		frame.free()
	#TODO: parse frames save files and load them
	for f in frames:
		var sc_templ : PackedScene = load(f)
		var frame : Frame = sc_templ.instantiate()
		frame.visible = false
		frame.frame_swap_called.connect(swap_frame_cb)
		#frame.commands_prpared.connect(frame_cmd_prepared)
		frame.device_added.connect(add_signals)
		frame.device_removed.connect(remove_signals)
		frame.device_renamed.connect(rename_singals)
		frame.load()
		nframes.add_child(frame)
	_silent = _s_bak #restore_silent_mode
	return false

func save_frames() -> Dictionary:
	return {}

func swap_frame_cb(frameName: String, linkName: String):
	for ch in nframes.get_children():
		ch.visible = false
		if ch is Frame and ch.frame_name == frameName:
			ch.visible = true
			ch.flash_link(linkName)

func _on_exit_pressed():
	for ch in nframes.get_children():
		if ch is Frame:
			ch.visible = false
	dummy.visible = true
	exit_called.emit()

func enter_frame(frame_name: String):
	for ch in nframes.get_children():
		if ch is Frame and ch.frame_name == frame_name:
			ch.visible = true
			dummy.visible = false

func _on_button_pressed():
	enter_frame("01")

func _on_button_2_pressed():
	enter_frame("02")

#------SIG-SIGNAL-SYSTEM
func set_shutup(silent: bool):
	_silent = silent

signal request_signal_list_updated()
var signals : Dictionary = {}

func frame_cmd_prepared(signals: Dictionary):
	#TODO: SEND COMMAND TO DREW SYSEM
	commands_prepared.emit(signals)
	
func get_request_signal_list() -> Array:
	return signals.keys()
	
func set_signal_values(in_sigs: Dictionary):
	#parse incoming signals
	for in_s in in_sigs:
		if not in_s in signals:
			print_debug("ERROR: INCOMING SIGNAL", in_s, "NOT FOUND")
		else:
			#TODO: FILTER UNCHANGED SIGNALS or uses it on DREW side
			#update devices info
			for dev in signals[in_s]["devs"]:
				dev.set_signal_values(in_s, in_sigs[in_s])

func add_signals(dev: Device):
	#check signal kind already exist
	var dsl : Array = dev.get_requested_signals()
	for ds in dsl:
		if signals.has(ds):
			signals[ds]["devs"].append(dev)
		else:
			signals[ds] = { "devs": [dev], "vals": [0] }
	if not _silent:
		request_signal_list_updated.emit()
	
func remove_signals(dev: Device):
	var dsl : Array = dev.get_requested_signals()
	for ds in dsl:
		if signals.has(ds):
			#check another users of this signal
			if signals[ds]["devs"].size() > 1: #remove only self
				signals[ds]["devs"].erase(dev)
			else: #remove full signal
				signals.erase(ds)
	if not _silent:
		request_signal_list_updated.emit()
	
func rename_singals(dev: Device, prev_name: String):
	var dsl : Array = dev.get_requested_signals()
	var new_name : String = dev.get_full_name()
	var oldsl : Array = []
	#add new signal
	for ds in dsl:
		oldsl.append(ds.replace(new_name, prev_name))
		if signals.has(ds):
			signals[ds]["devs"].append(dev)
		else:
			signals[ds] = { "devs": [dev], "vals": [0] }
	#remove from prevous signals
	for ds in oldsl:
		if signals.has(ds):
			#check another users of this signal
			if signals[ds]["devs"].size() > 1: #remove only self
				signals[ds]["devs"].erase(dev)
			else: #remove full signal
				signals.erase(ds)
	if not _silent:
		request_signal_list_updated.emit()
