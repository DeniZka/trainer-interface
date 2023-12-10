class_name Device
extends Node2D

@onready var _timer = Timer.new()
@onready var _device_menu : DeviceMenu = null
var menu_active : bool = true:
	set(val):
		menu_active = val
		_device_menu.enabled = val

signal device_menu_popped(dev: Device, state: bool)

func printLabel(mainName, subName):
	for child in get_children():
		if child is Label:
			child.text = mainName + "\n" + subName

@export var main_name : String = "KBAXX":
	set(val):
		main_name = val
		if not is_node_ready() : await ready
		printLabel(val, sub_name)

@export var sub_name : String = "AAXXX":
	set(val):
		if not is_node_ready() : await ready
		sub_name = val
		printLabel(main_name, val)

signal exchange_prepared(out_signals: Dictionary)
signal _await_interrupt(ir_status: bool) #0-got correct signal 1 - timeout

var _is_await_response: bool = false
var _response : Dictionary = {}

var confirm_timeout : float = 1.0

func _ready():
	_timer.timeout.connect(_on_timer_timeout)
	add_child(_timer)
	#get device menu
	for ch in get_children():
		if ch is DeviceMenu:
			_device_menu = ch
			_device_menu.popped.connect(self_menu_popped)
			break

#use await send_signals(signals, true)  in case of await_confirm 
func send_signal(sigName: String, sigVal: Variant, await_confirm : bool = false) -> bool:
	var d : Dictionary = {main_name+sub_name+"_"+sigName: sigVal}
	exchange_prepared.emit(d)
	var result : bool = true
	if await_confirm:
		_response = d #FIXME .duolicate() ???
		_is_await_response = true
		_timer.start(confirm_timeout)
		result = await _await_interrupt
		_is_await_response = false
	return result
	pass
	
var requested_signals = []  #setup this one in _init fuunc of child

func get_requested_signals() -> Array:
	return requested_signals
	
func update_requested_signals(sigs: Array):
	requested_signals = []
	for sig in sigs:
		requested_signals.append(main_name+sub_name+"_"+sig)

func set_exchange_data(in_signals: Dictionary) -> void:
	#check if searching for signal is actual
	if _is_await_response and in_signals.has(_response["name"]):
		if in_signals[_response["name"]] == _response["value"]: 
			_await_interrupt.emit(true)

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
