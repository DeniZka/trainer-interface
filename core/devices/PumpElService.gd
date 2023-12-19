@tool 
class_name PumpEl extends Device 

@onready var sprites = $sprites
@onready var pump = $sprites/Ellipse
@onready var elDrive = $sprites/ElDrive

const CLOSE_RGB = Color(0, 0.9176470588235294, 0) 
const OPEN_RGB = Color(1, 0.5803921568627451, 0.1568627450980392) 
const DARK_RGB = Color(0.8, 0.8, 0.8)
const DEFAULT_RGB = Color(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)
const BLACK_RGB = Color(0, 0, 0)
const REFUSAL_RGB = Color(0.7568627450980392, 0, 0.7568627450980392)


@export_category("Pump") 

@export_range(-180.0, 180.0, 90.0, "degrees") var rotate: float = 0.0:
	set(val):
		rotate = val
		if not is_node_ready(): await ready
		elDrive.rotation_degrees = val

enum PUMP_STATE  {ST_UNKNOWN, ST_OPENED, ST_CLOSED} 
@export_enum("неизвестно:0", "включен:1", "выключен:2") var pmp_state : int = PUMP_STATE.ST_UNKNOWN: 
	set(val):
		pmp_state = val
		if not is_node_ready(): await ready
		pump.modulate = DEFAULT_RGB
		elDrive.modulate = BLACK_RGB
		if val == PUMP_STATE.ST_OPENED: 
			if refusal == true:
				elDrive.modulate = REFUSAL_RGB
			pump.modulate = OPEN_RGB
		if val == PUMP_STATE.ST_CLOSED:
			if refusal == true:
				elDrive.modulate = REFUSAL_RGB
			pump.modulate = CLOSE_RGB

@export var refusal: bool = false:
	set(val):
		refusal = val
		if not is_node_ready() : await ready
		if val:
			elDrive.modulate = REFUSAL_RGB
		else:
			elDrive.modulate = BLACK_RGB

func _on_maincir_popped(state):
	if state :
		z_index = 5
		sprites.z_index = 5
	else:
		z_index = 0
		sprites.z_index = 0
