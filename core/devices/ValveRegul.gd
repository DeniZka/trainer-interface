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
@onready var accept = $accept
@onready var openb = $"main-cir/open"
@onready var closeb = $"main-cir/close"
@onready var stopb = $"main-cir/stop"
@onready var automanb = $"main-cir/AutoManual"
@onready var refusalButton : PopButton = $"main-cir/refusal"
@onready var maincir = $"main-cir"
@onready var refchpopstate : bool = false

const CLOSE_RGB = Color(0, 0.9176470588235294, 0) 
const OPEN_RGB = Color(1, 0.5803921568627451, 0.1568627450980392) 
const DARK_RGB = Color(0.8, 0.8, 0.8)
const DEFAULT_RGB = Color(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)
const REFUSAL_RGB = Color(0.7568627450980392, 0, 0.7568627450980392)
const NOCOLOR_RGB = Color(1, 1, 1, 0)
var buttons = []
var signal_to_send_true = ""

#export inspector variables
@export_category("Valve_Regul") #create comfort category
const valve_stat_map = {0:"неизвестно", 1:"отказ", 2:"открыт",3:"открывается",4:"закрыт",5:"закрывается",6:"в проме",8:"неизвестно"}
@export_enum("неизвестно", "отказ", "открыт", "закрыт", "в проме", "открывается", "закрывается") var valve_stat : String = "неизвестно": #same as VLV_STATE indexes
	set(val):
		valve_stat = val
		if not is_node_ready(): await ready
		player.stop()
		if val == "отказ":
			player.play("refusal")
		else:
			valveLeft.modulate = DEFAULT_RGB
			valveRight.modulate = DEFAULT_RGB

		if val == "открыт": #direct states
			valveLeft.modulate = OPEN_RGB
			valveRight.modulate = OPEN_RGB

		if val == "закрыт":
			valveLeft.modulate = CLOSE_RGB
			valveRight.modulate = CLOSE_RGB
		if val == "в проме":
			valveLeft.modulate = CLOSE_RGB
			valveRight.modulate = OPEN_RGB
		if val == "открывается":
			valveLeft.modulate = CLOSE_RGB
			valveRight.modulate = OPEN_RGB
			#player.play("opening")
		if val == "закрывается":
			valveLeft.modulate = CLOSE_RGB
			valveRight.modulate = OPEN_RGB
			#player.play("closing")

enum VLV_MODE {ST_UNKNOWN, ST_REMOTE, ST_AUTO}
@export_enum("неизвестно:0", "удаленный:1", "автоматический:2") var vlv_mode : int = VLV_MODE.ST_UNKNOWN: #same as VLV_STATE indexes
	set(val):
		vlv_mode = val
		if not is_node_ready(): await ready
		elMotor.modulate = DEFAULT_RGB
		if val == VLV_MODE.ST_AUTO: #direct states
			elMotor.modulate = OPEN_RGB
		if val == VLV_MODE.ST_REMOTE:
			elMotor.modulate = CLOSE_RGB

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


func _ready():
	super._ready()
	buttons = [openb, closeb, stopb, refusalButton, automanb]
	vlv_mode = VLV_MODE.ST_UNKNOWN
	update_requested_signals(
		[
			"is_state", #СВБУ "Состояние сборный сигнал" [double] 
			"is_alarm", #СВБУ "Авария сборный сигнал" [double]
			"is_control", #режим управления
			"is_power", #СВБУ "Питание сборный сигнал" [double]
		]
	)
	
func _enter_tree():
	if not UserProfile.updated.is_null():
		UserProfile.updated.connect(_on_new_profile)
		if UserProfile.has_admin_role():
			refusalButton.disabled = false

func _on_new_profile():
	if not UserProfile.has_admin_role():
		refusalButton.disabled = false
	
func untuggle_others_except(aliveb: PopButton):
	for b in buttons:
		if aliveb != b and b.toggled:
			b.toggled = false
			
func everyone_outline(color: Color):
	for b in buttons:
		(b as PopButton).outline_color = color
	maincir.outline_color = color
	accept.outline_color = color

func _on_maincir_popped(state):
	if state :
		everyone_outline(DARK_RGB)
		z_index = 5
		sprites.z_index = 5
	else:
		z_index = 0
		sprites.z_index = 0


func _on_close_b_toggled(is_down):
	if is_down:
		untuggle_others_except(closeb)
	#send_signal("YB02", [is_down])
	accept.pop = is_down
	if is_down:
		everyone_outline(CLOSE_RGB)
		signal_to_send_true = "YB02"
		#to_send_with_confirm = {"YB02": [true]}


func _on_open_b_toggled(is_down):
	if is_down:
		untuggle_others_except(openb)
	#send_signal("YB01", [is_down])
	accept.pop = is_down
	if is_down:
		everyone_outline(OPEN_RGB)
		signal_to_send_true = "YB01"


func _on_stop_b_toggled(is_down):
	if is_down :
		untuggle_others_except(stopb)
	accept.pop = is_down
	if is_down:
		everyone_outline(DARK_RGB)
		signal_to_send_true = "YB91"


func _on_refusal_b_toggled(is_down):
	if not is_node_ready() : await ready
	if is_down:
		everyone_outline(REFUSAL_RGB)
		untuggle_others_except(refusalButton)
	refusalButton.pop_childs(is_down)

func _on_auto_manual_b_toggled(is_down):
	if is_down :
		untuggle_others_except(automanb)
	accept.pop = is_down
	if is_down:
		everyone_outline(DARK_RGB)
		signal_to_send_true = "YB23"

func _on_accept_b_pressed():
	#to_send_with_confirm.merge({"YB92":[true]})
	var result = await send_signal(signal_to_send_true, [true], true)
	await get_tree().create_timer(1.0).timeout
	send_signals({signal_to_send_true: [false]})
	signal_to_send_true = ""
	#FIXME: test
	openb.toggled = false
	closeb.toggled = false
	stopb.toggled = false
	automanb.toggled = false

func _on_auto_manual_b_pressed():
	#untuggle_others_except(null)
	##send_signals({"YB23": [true]})
	#var result = await send_signal("YB23", [true], true)
	##await get_tree().create_timer(0.5).timeout
	##send_signal()
	#send_signals({"YB23": [false]})
	pass
	

	
func update_device_state(sig: String, vals: Array):
	match sig:
		"is_state":
			valve_stat = valve_stat_map[int(vals[0])]
		"is_power":
			power = power_map[int(vals[0])]
		"is_control":
			vlv_mode = int(vals[0])
			if vlv_mode == VLV_MODE.ST_REMOTE:
				closeb.disabled = false
				openb.disabled = false
				if automanb.pop == true:
					#if not closeb.pop:
					closeb.pop = true
					#if not openb.pop:
					openb.pop = true
			if vlv_mode == VLV_MODE.ST_AUTO:
				vlv_mode = VLV_MODE.ST_AUTO
				closeb.pop = false
				openb.pop = false
				closeb.disabled = true
				openb.disabled = true



