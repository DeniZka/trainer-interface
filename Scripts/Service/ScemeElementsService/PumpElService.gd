extends Node2D

@onready var btnArea = $menuArea
@onready var pump = $Ellipse
@onready var elDrive = $ElDrive
@onready var open = $menuArea/menuColShape/Bg/On/On2
@onready var close = $menuArea/menuColShape/Bg/Off/Off2
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
		pump.modulate = Color(OPEN_RGB.red, OPEN_RGB.green, OPEN_RGB.blue)


func _on_off_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		pump.modulate = Color(CLOSE_RGB.red, CLOSE_RGB.green, CLOSE_RGB.blue)


func _on_on_mouse_entered():
	open.modulate = Color(OPEN_RGB.red, OPEN_RGB.green, OPEN_RGB.blue)

func _on_on_mouse_exited():
	open.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)



func _on_off_mouse_entered():
	close.modulate = Color(CLOSE_RGB.red, CLOSE_RGB.green, CLOSE_RGB.blue)

func _on_off_mouse_exited():
	close.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)



func _on_rotate_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		elDrive.rotation_degrees += 90

func _on_rotate_mouse_entered():
	rotate.modulate = Color(DARK_RGB.red, DARK_RGB.green, DARK_RGB.blue)

func _on_rotate_mouse_exited():
	rotate.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)



func _on_flip_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if elDrive.scale.x == -1:
			elDrive.scale.x = 1
		else:
			elDrive.scale.x = -1

func _on_flip_mouse_entered():
	flip.modulate = Color(DARK_RGB.red, DARK_RGB.green, DARK_RGB.blue)

func _on_flip_mouse_exited():
	flip.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)
