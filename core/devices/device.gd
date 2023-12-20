class_name Device
extends Node2D

@onready var _timer = Timer.new()
@onready var _device_menu : DeviceMenu = null
var menu_active : bool = true:
	set(val):
		if _device_menu:
			menu_active = val
			_device_menu.enabled = val
			
var label : Label = null
var full_name : String

signal device_menu_popped(dev: Device, state: bool)
signal name_changed(dev: Device, prev_name: String) #4 update signals list
signal signals_emited(out_signals: Dictionary)
signal _await_interrupt(ir_status: bool) #0-got correct signal 1 - timeout

func printLabel():
	for child in get_children():
		if child is Label:
			child.text = main_name + "\n" + sub_name

@export var main_name : String = "KBAXX":
	set(val):
		var prev_name = main_name + sub_name
		main_name = val
		full_name = main_name+sub_name
		name_changed.emit(self, prev_name)
		if not is_node_ready() : await ready
		printLabel()

@export var sub_name : String = "AAXXX":
	set(val):
		var prev_name = main_name + sub_name
		sub_name = val
		full_name = main_name+sub_name		
		name_changed.emit(self, prev_name)
		if not is_node_ready() : await ready
		printLabel()

var _is_await_response: bool = false
var _response : Dictionary = {"name": "", "values": []}

var confirm_timeout : float = 1.0

func _ready():
	self.child_entered_tree.connect(label_entered_tree)
	full_name = main_name + sub_name #do not forget
	_timer.timeout.connect(_on_timer_timeout)
	add_child(_timer)
	#get device menu
	for ch in get_children():
		if ch is DeviceMenu:
			_device_menu = ch
			_device_menu.popped.connect(self_menu_popped)
			break

func get_full_name() -> String:
	return full_name

#use await send_signals(signals, true)  in case of await_confirm 
func send_signal(sigName: String, sigVal: Array, await_confirm : bool = false) -> bool:
	signals_emited.emit({main_name+sub_name+"_"+sigName: sigVal})
	var result : bool = true
	if await_confirm:
		_response["name"] = main_name+sub_name+"_"+sigName #FIXME .duolicate() ???
		_response["values"] = sigVal
		_is_await_response = true
		_timer.start(confirm_timeout)
		result = await _await_interrupt
		_is_await_response = false
	return result
	
func send_signals(signals: Dictionary):
	var out = {}
	for s in signals:
		out[main_name+sub_name+"_"+s] = signals[s]
	signals_emited.emit(out)
	
var requested_signals = []  #setup this one in _init fuunc of child

func get_requested_signals() -> Array:
	return requested_signals
	
func update_requested_signals(sigs: Array):
	requested_signals = []
	for sig in sigs:
		requested_signals.append(main_name+sub_name + "_" + sig)

func update_device_state(sig: String, vals: Array): 
	#virtual for children device
	pass
	
func set_signal_values(in_sig: String, in_values: Array):
	#check if searching for signal is actual
	if _is_await_response and in_sig == _response["name"]:
		var same_as_await : bool = true
		for i in range(in_values.size()):
			if int(in_values[i]) != int(_response["values"][i]): #FIXME Latter incoming is a float(and looks lika int) & have bool
				same_as_await = false #FIXME: array and single 
		if same_as_await:
			_await_interrupt.emit(true)
	#TODO: strip signal
	var rep_str = full_name + "_"
	update_device_state(in_sig.replace(rep_str, ""), in_values)

func _on_timer_timeout():
	if _is_await_response: #check if timeout signal is actial
		_await_interrupt.emit(false)

func got_device_menu():
	if _device_menu:
		return true
	else:
		return false

func close_menu():
	if _device_menu:
		_device_menu.pop = false

func self_menu_popped(state: bool):
	device_menu_popped.emit(self, state)
	
func label_entered_tree(node: Node):
	if node is Label:
		label = node
