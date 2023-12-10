class_name Device
extends Node2D

@onready var _timer = Timer.new()

signal exchange_prepared(out_signals: Dictionary)
signal _await_interrupt(ir_status: bool) #0-got correct signal 1 - timeout

var _is_await_response: bool = false
var _response : Dictionary = {}

var confirm_timeout : float = 1.0

func _ready():
	_timer.timeout.connect(_on_timer_timeout)
	add_child(_timer)

#use await send_signals(signals, true)  in case of await_confirm 
func send_signals(sigs: Dictionary, await_confirm : bool = false) -> bool:
	exchange_prepared.emit(sigs)
	var result : bool = true
	if await_confirm:
		_response = sigs #FIXME .duolicate() ???
		_is_await_response = true
		_timer.start(confirm_timeout)
		result = await _await_interrupt
		_is_await_response = false
	return result
	pass
	
var requestd_signals = []  #setup this one in _init fuunc of child

func get_requested_signals() -> Array:
	return requestd_signals

func set_exchange_data(in_signals: Dictionary) -> void:
	#check if searching for signal is actual
	if _is_await_response and in_signals.has(_response["name"]):
		if in_signals[_response["name"]] == _response["value"]: 
			_await_interrupt.emit(true)

func _on_timer_timeout():
	if _is_await_response: #check if timeout signal is actial
		_await_interrupt.emit(false)

		
