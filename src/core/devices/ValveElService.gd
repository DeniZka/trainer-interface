@tool 
class_name ValveEl extends Device

@onready var sprites = $sprites
@onready var valveLeft = $sprites/ValveLeft
@onready var valveLeftRefusal = $sprites/ValveLeftRefusal
@onready var valveRight = $sprites/ValveRight
@onready var valveRightRefusal = $sprites/ValveRightRefusal
@onready var elMotor = $sprites/ValveElectricMotor
@onready var elMotorRefusal = $sprites/ValveElectricMotorRefusal
@onready var accept = $accept
@onready var openb = $"main-cir/open"
@onready var closeb = $"main-cir/close"
@onready var stopb = $"main-cir/stop"
@onready var elConn = $sprites/ValveConn
@onready var player = $signal_play
@onready var refusalButton : PopButton = $"main-cir/refusal"
@onready var maincir = $"main-cir"
@onready var refpopchstate : bool = false
var buttons = []

const CLOSE_RGB = Color(0, 0.9176470588235294, 0) 
const OPEN_RGB = Color(1, 0.5803921568627451, 0.1568627450980392) 
const DARK_RGB = Color(0.8, 0.8, 0.8)
const DEFAULT_RGB = Color(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)
const REFUSAL_RGB = Color8(255, 20, 253)
const NOCOLOR_RGB = Color(1, 1, 1, 0)

#singal of open/close
var to_send_with_confirm : Dictionary = {}

@export_category("Valve_El") 

@export_range(-180.0, 180.0, 90.0, "degrees") var Rotate: float = 0.0:
	set(val):
		Rotate = val
		if not is_node_ready(): await ready
		valveLeft.rotation_degrees = val
		valveLeftRefusal.rotation_degrees = val
		valveRight.rotation_degrees = val
		valveRightRefusal.rotation_degrees = val
		elConn.rotation_degrees = val
		elMotor.rotation_degrees = val
		elMotorRefusal.rotation_degrees = val

const valve_stat_map = {0:"неизвестно", 1:"отказ", 2:"открыт",3:"открывается",4:"закрыт",5:"закрывается",6:"в проме"}
@export_enum("неизвестно", "отказ", "открыт", "закрыт", "в проме", "открывается", "закрывается") var valve_stat : String = "неизвестно": #same as VLV_STATE indexes
	set(val):
		valve_stat = val
		if not is_node_ready(): await ready
		elMotor.modulate = DEFAULT_RGB
		valveLeft.modulate = DEFAULT_RGB
		valveRight.modulate = DEFAULT_RGB
		player.stop()
		if val == "открыт": #direct states
			valveLeft.modulate = OPEN_RGB
			valveRight.modulate = OPEN_RGB
		if val == "отказ":
			valveLeft.modulate = REFUSAL_RGB
			valveRight.modulate = REFUSAL_RGB
			elMotor.modulate = REFUSAL_RGB 
		if val == "закрыт":
			valveLeft.modulate = CLOSE_RGB
			valveRight.modulate = CLOSE_RGB
		if val == "в проме":
			valveRight.modulate = OPEN_RGB
			valveLeft.modulate = CLOSE_RGB
		if val == "открывается":
			valveLeft.modulate = CLOSE_RGB
			valveRight.modulate = DEFAULT_RGB
			player.play("opening")
		if val == "закрывается":
			valveLeft.modulate = DEFAULT_RGB
			valveRight.modulate = OPEN_RGB
			player.play("closing")

@export_group("Refusal")
const power_map = {2:true, 1:false, 0:false}
@export var power: bool = false:
	set(val):
		power = val
		if not is_node_ready() : await ready
		if val:
			elMotorRefusal.modulate = REFUSAL_RGB
		else:
			elMotorRefusal.modulate = NOCOLOR_RGB

const control_map = {2:false, 1:true, 0:false}
@export var control: bool = false:
	set(val):
		control = val		
		if not is_node_ready() : await ready
		if val:
			elMotorRefusal.modulate = REFUSAL_RGB
		else:
			elMotorRefusal.modulate = NOCOLOR_RGB
@export_group("")

func _ready():
	super._ready()
	UserProfile.updated.connect(_on_new_profile)
	if UserProfile.has_admin_role():
		refusalButton.disabled = false
		
	buttons = [openb, closeb, stopb, refusalButton]
	update_requested_signals(
		[
			"is_state", #СВБУ "Состояние сборный сигнал" [double] 
			"is_alarm", #СВБУ "Авария сборный сигнал" [double]
			"is_power", #СВБУ "Питание сборный сигнал" [double]
		]
	)
	
func _on_new_profile():
	if not UserProfile.has_admin_role():
		refusalButton.disabled = false
	
func _on_refusal_b_toggled(is_down):
	if not is_node_ready() : await ready
	if is_down:
		everyone_outline(REFUSAL_RGB)
		untuggle_others_except(refusalButton)
	refusalButton.pop_childs(is_down)

#popup ordering repair
func _on_maincir_popped(state):
	if state :
		everyone_outline(DARK_RGB)
		#maincir.outline_color = NOCOLOR_RGB
		z_index = 5
		sprites.z_index = 5
	else:
		accept.pop = false
		z_index = 0
		sprites.z_index = 0
	pass # Replace with function body.


func untuggle_others_except(aliveb: PopButton):
	for b in buttons:
		if aliveb != b and b.toggled:
			b.toggled = false
			
func everyone_outline(color: Color):
	for b in buttons:
		(b as PopButton).outline_color = color
	maincir.outline_color = color
	accept.outline_color = color

func _on_close_b_toggled(is_down):
	if is_down:
		untuggle_others_except(closeb)
	#send_signal("YB02", [is_down])
	accept.pop = is_down
	if is_down:
		everyone_outline(CLOSE_RGB)
		to_send_with_confirm = {"YB02": [true]}

func _on_open_b_toggled(is_down):
	if is_down:
		untuggle_others_except(openb)
	#send_signal("YB01", [is_down])
	accept.pop = is_down
	if is_down:
		everyone_outline(OPEN_RGB)
		to_send_with_confirm = {"YB01": [true]}

func _on_stop_b_toggled(is_down):
	if is_down :
		untuggle_others_except(stopb)
	accept.pop = is_down
	if is_down:
		everyone_outline(DARK_RGB)
		to_send_with_confirm = {"YB91": [true]}

func _on_accept_b_pressed():
	to_send_with_confirm.merge({"YB92":[true]})
	send_signals(to_send_with_confirm)
	to_send_with_confirm = {}
	#FIXME: test
	openb.toggled = false
	closeb.toggled = false
	stopb.toggled = false

func update_device_state(sig: String, vals: Array):
	match sig:
		"is_state":
			valve_stat = valve_stat_map[int(vals[0])]
		"is_power":
			power = power_map[int(vals[0])]
		"is_alarm":
			control = control_map[int(vals[0])]





