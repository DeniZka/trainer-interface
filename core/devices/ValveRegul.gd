@tool #set design-time usability
class_name ValveRegul extends Device #generate class name for node searching type

@onready var sprites = $sprites
@onready var valveLeft = $sprites/ValveLeft
@onready var valveRight = $sprites/ValveRight
@onready var elMotor = $sprites/ValveElectricMotor
@onready var elArrow = $sprites/ValveElArrow
@onready var player = $signal_play
@onready var elMotorRefusal = $sprites/ValveElectricMotorRefusal
@onready var valveLeftRefusal = $sprites/ValveLeftRefusal
@onready var valveRightRefusal = $sprites/ValveRightRefusal
@onready var refusalButton : PopButton = $"main-cir/refusal"
@onready var refchpopstate : bool = false

const CLOSE_RGB = Color(0, 0.9176470588235294, 0) 
const OPEN_RGB = Color(1, 0.5803921568627451, 0.1568627450980392) 
const DARK_RGB = Color(0.8, 0.8, 0.8)
const DEFAULT_RGB = Color(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)
const REFUSAL_RGB = Color(0.7568627450980392, 0, 0.7568627450980392)
const NOCOLOR_RGB = Color(1, 1, 1, 0)

#export inspector variables
@export_category("Valve_Regul") #create comfort category
enum VLV_STATE  {ST_UNKNOWN, ST_OPENED, ST_CLOSED, ST_WORKING}
@export_enum("неизвестно:0", "открыт:1", "закрыт:2", "в работе:3") var valve_stat : int = VLV_STATE.ST_UNKNOWN: #same as VLV_STATE indexes
	set(val):
		valve_stat = val
		if not is_node_ready(): await ready
		#default states
		valveLeft.modulate = DEFAULT_RGB
		valveRight.modulate = DEFAULT_RGB
		if val == VLV_STATE.ST_OPENED: #direct states 
			valveLeft.modulate = OPEN_RGB
			valveRight.modulate = OPEN_RGB
		if val == VLV_STATE.ST_CLOSED:
			valveLeft.modulate = CLOSE_RGB
			valveRight.modulate = CLOSE_RGB
		if val == VLV_STATE.ST_WORKING:
			valveLeft.modulate = CLOSE_RGB
			valveRight.modulate = OPEN_RGB

enum VLV_MODE {ST_UNKNOWN, ST_AUTO, ST_REMOTE}
@export_enum("неизвестно:0", "автоматический:1", "удаленный:2") var vlv_mode : int = VLV_MODE.ST_UNKNOWN: #same as VLV_STATE indexes
	set(val):
		vlv_mode = val
		if not is_node_ready(): await ready
		elMotor.modulate = DEFAULT_RGB
		if val == VLV_MODE.ST_AUTO: #direct states
			elMotor.modulate = OPEN_RGB
		if val == VLV_MODE.ST_REMOTE:
			elMotor.modulate = CLOSE_RGB

@export_group("Refusal")
@export var power: bool = false:
	set(val):
		power = val		
		if not is_node_ready() : await ready
		if val:
			player.play("refusal")
		else:
			player.stop()

@export var control: bool = false:
	set(val):
		control = val
		if not is_node_ready() : await ready
		if val:
			elMotorRefusal.modulate = REFUSAL_RGB
		else:
			elMotorRefusal.modulate = NOCOLOR_RGB
@export_group("")

@export_range(-180.0, 180.0, 90.0, "degrees") var Rotate: float = 0.0:
	set(val):
		Rotate = val
		if not is_node_ready(): await ready
		valveLeft.rotation_degrees = val
		valveLeftRefusal.rotation_degrees = val
		valveRight.rotation_degrees = val
		valveRightRefusal.rotation_degrees = val
		elArrow.rotation_degrees = val
		elMotor.rotation_degrees = val
		elMotorRefusal.rotation_degrees = val

func _on_refusal_b_pressed():
	if not is_node_ready() : await ready
	refchpopstate = not refchpopstate
	refusalButton.pop_childs(refchpopstate)
	pass # Replace with function body.

func _on_refusal_b_pop_hide():
	if not is_node_ready() : await ready
	refchpopstate = false
	refusalButton.pop_childs(refchpopstate)


func _on_maincir_popped(state):
	if state :
		z_index = 5
		sprites.z_index = 5
	else:
		z_index = 0
		sprites.z_index = 0
