class_name FrameManager
extends Node2D

###USAGE:
# signals
# request_signal_list_updated()  appeared when request signal list changed(add/remove/move) can spam when frame loading
# outgoing_signals_ready() appered once if added signals in empty outgoing list
#
# functions:
# load_frames(..) loads frames when load can inform sysytem of every dev signals adding
# get_request_signal_list() ask for signals devices wanted
# set_signal_values(sig: Dict) post signals for devices
# get_outgoing_signals() -> Dict   receives all signas generated by devices 
#
# default signal construction is a Dict
# {
#   "Signame": [Sigval1, Sigval2, ..],
#	..
# }


signal exit_called() #emit when user wants to exit system
signal commands_prepared(signals: Dictionary)
signal outgoing_signals_ready()

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
		frame.device_added.connect(add_signals)
		frame.device_removed.connect(remove_signals)
		frame.device_renamed.connect(rename_singals)
		frame.load()
		nframes.add_child(frame)
	_silent = _s_bak #restore_silent_mode
	return false

func save_frames() -> Dictionary:
	return {}

#----SWAP FRME SYSTEM----
func swap_frame_cb(frameName: String, linkName: String):
	for ch in nframes.get_children():
		ch.visible = false
		if ch is Frame and ch.frame_name == frameName:
			ch.visible = true
			ch.flash_link(linkName)

func _on_exit_pressed():
	RPC.get_server_list()
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
signal request_signal_list_updated()
var signals : Dictionary = {}

func set_shutup(silent: bool):
	_silent = silent

func get_request_signal_list() -> Array:
	return signals.keys()
	
func set_signal_values(in_sigs: Dictionary):
	#parse incoming signals
	if not in_sigs.is_empty():
		Log.trace("got signals %s .." % in_sigs.keys()[0])
	for in_s in in_sigs:
		if not in_s in signals:
			print_debug("ERROR: INCOMING SIGNAL", in_s, "NOT FOUND")
		else:
			#TODO: FILTER UNCHANGED SIGNALS or uses it on DREW side
			#update devices info
			var devs = signals[in_s]
			for dev in signals[in_s]:
				dev.set_signal_values(in_s, in_sigs[in_s])

func add_signals(dev: Device):
	#subscribe devise outgoing signal transtit
	dev.signals_emited.connect(device_signal_emited)
	
	#check signal kind already exist
	var dsl : Array = dev.get_requested_signals()
	for ds in dsl:
		if signals.has(ds):
			signals[ds].append(dev)
		else:
			signals[ds] =  [dev]
	if not _silent:
		request_signal_list_updated.emit()
	
func remove_signals(dev: Device):
	var dsl : Array = dev.get_requested_signals()
	for ds in dsl: #FIXME: erasy on interaitve FIXME!!!!
		if signals.has(ds):
			#check another users of this signal
			if signals[ds].size() > 1: #remove only self
				signals[ds].erase(dev)
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
			signals[ds].append(dev)
		else:
			signals[ds] = [dev]
	#remove from prevous signals
	for ds in oldsl:
		if signals.has(ds):
			#check another users of this signal
			if signals[ds].size() > 1: #remove only self
				signals[ds].erase(dev)
			else: #remove full signal
				signals.erase(ds)
	if not _silent:
		request_signal_list_updated.emit()
		
var outgoing_signals : Dictionary = {}

func device_signal_emited(sig: Dictionary):
	var was_empty : bool = outgoing_signals.is_empty()
	#overwrite if changed
	outgoing_signals.merge(sig, true)
	if was_empty:
		outgoing_signals_ready.emit() #call once if empty

func get_outgoing_signals() -> Dictionary:
	var result : Dictionary = outgoing_signals.duplicate()
	outgoing_signals = {} #clean outgoing list 
	return result
	


func _on_inizialization_button_pressed():
	RPC.server_control.rpc(SITCommand.Init)

func _on_play_button_pressed():
	RPC.server_control.rpc(SITCommand.Play)

func _on_step_button_pressed():
	RPC.server_control.rpc(SITCommand.Step)

func _on_pause_button_pressed():
	RPC.server_control.rpc(SITCommand.Pause)

func _on_stop_button_pressed():
	RPC.server_control.rpc(SITCommand.Stop)
