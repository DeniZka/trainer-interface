extends Node2D

@onready var btnArea = $menuArea
@onready var valveLeft = $ValveEl
@onready var valveRight = $ValveEl2
@onready var elMotor = $ValveElectricMotor
@onready var elArrow = $ValveElArrow
@onready var open = $menuArea/menuColShape/Bg/On/On2
@onready var close = $menuArea/menuColShape/Bg/Off/Off2
@onready var motorClose = $menuArea/menuColShape/Bg/Motor/Motor
@onready var CheckValveOnOff = $menuArea/menuColShape/Bg/CheckValveOnOff/CheckValveOnOff
@onready var CheckValveOn = $menuArea/menuColShape/Bg/CheckValveOn/CheckValveOn
@onready var CheckValveOff = $menuArea/menuColShape/Bg/CheckValveOff/CheckValveOff
@onready var rotate = $menuArea/menuColShape/Bg/Rotate/Rotate
@onready var flip = $menuArea/menuColShape/Bg/Flip/Flip

var CLOSE_RGB = CustomRGBDto.new(0, 0.9176470588235294, 0) 
var OPEN_RGB = CustomRGBDto.new(1, 0.5803921568627451, 0.1568627450980392) 
var DARK_RGB = CustomRGBDto.new(0.8, 0.8, 0.8)
var DEFAULT_RGB = CustomRGBDto.new(1, 1, 1)



func _on_active_area_mouse_entered():
	btnArea.visible = true

func _on_menu_area_mouse_exited():
	btnArea.visible = false



func _on_on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		valveLeft.modulate = Color(OPEN_RGB.red, OPEN_RGB.green, OPEN_RGB.blue)
		valveRight.modulate = Color(OPEN_RGB.red, OPEN_RGB.green, OPEN_RGB.blue)

func _on_on_mouse_entered():
	open.modulate = Color(OPEN_RGB.red, OPEN_RGB.green, OPEN_RGB.blue)

func _on_on_mouse_exited():
	open.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)



func _on_off_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		valveLeft.modulate = Color(CLOSE_RGB.red, CLOSE_RGB.green, CLOSE_RGB.blue)
		valveRight.modulate = Color(CLOSE_RGB.red, CLOSE_RGB.green, CLOSE_RGB.blue)

func _on_off_mouse_entered():
	close.modulate = Color(CLOSE_RGB.red, CLOSE_RGB.green, CLOSE_RGB.blue)

func _on_off_mouse_exited():
	close.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)



func _on_check_valve_on_off_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		valveLeft.modulate = Color(OPEN_RGB.red, OPEN_RGB.green, OPEN_RGB.blue)
		valveRight.modulate = Color(CLOSE_RGB.red, CLOSE_RGB.green, CLOSE_RGB.blue)

func _on_check_valve_on_off_mouse_entered():
	CheckValveOnOff.modulate = Color(OPEN_RGB.red, OPEN_RGB.green, OPEN_RGB.blue)

func _on_check_valve_on_off_mouse_exited():
	CheckValveOnOff.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)



func _on_check_valve_on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		valveLeft.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)
		valveRight.modulate = Color(OPEN_RGB.red, OPEN_RGB.green, OPEN_RGB.blue)

func _on_check_valve_on_mouse_entered():
	CheckValveOn.modulate = Color(OPEN_RGB.red, OPEN_RGB.green, OPEN_RGB.blue)

func _on_check_valve_on_mouse_exited():
	CheckValveOn.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)



func _on_check_valve_off_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		valveLeft.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)
		valveRight.modulate = Color(CLOSE_RGB.red, CLOSE_RGB.green, CLOSE_RGB.blue)

func _on_check_valve_off_mouse_entered():
	CheckValveOff.modulate = Color(CLOSE_RGB.red, CLOSE_RGB.green, CLOSE_RGB.blue)

func _on_check_valve_off_mouse_exited():
	CheckValveOff.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)



func _on_rotate_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		valveLeft.rotation_degrees += 90
		valveRight.rotation_degrees += 90
		elArrow.rotation_degrees += 90
		elMotor.rotation_degrees += 90

func _on_rotate_mouse_entered():
	rotate.modulate = Color(DARK_RGB.red, DARK_RGB.green, DARK_RGB.blue)

func _on_rotate_mouse_exited():
	rotate.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)



func _on_flip_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if valveLeft.scale.x == -1:
			valveLeft.scale.x = 1
			valveRight.scale.x = 1
		else:
			valveLeft.scale.x = -1
			valveRight.scale.x = -1

func _on_flip_mouse_entered():
	flip.modulate = Color(DARK_RGB.red, DARK_RGB.green, DARK_RGB.blue)

func _on_flip_mouse_exited():
	flip.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)



func _on_motor_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		elMotor.modulate = Color(CLOSE_RGB.red, CLOSE_RGB.green, CLOSE_RGB.blue)

func _on_motor_mouse_entered():
	motorClose.modulate = Color(CLOSE_RGB.red, CLOSE_RGB.green, CLOSE_RGB.blue)

func _on_motor_mouse_exited():
	motorClose.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)
