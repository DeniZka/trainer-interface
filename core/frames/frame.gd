class_name Frame
extends Node2D

signal frame_swap_called(frame_name: String, link_name: String)
signal commands_prpared(signals: Dictionary)

@onready var jobjects : Dictionary = {
	"lines":[], #array of lines
	"valves1":[], 
	"dots":[] 
	#and so on
}

@export var frame_name : String = "01"
var background : ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	#TODO: LOAD FRAME FILE
	
	for ch in get_children():
		if ch is ColorRect and ch.name == "background":
			background = ch
			background.gui_input.connect(_on_background_input)
		
		if ch is Device and ch.got_device_menu():
			ch.device_menu_popped.connect(device_menu_popped)
			ch.commands_prepared.connect(devs_cmd_prepared)
			
		if ch is FrameLink:
			ch.frame_swap_called.connect(swap_frame_cb)
	
	#example how to add valve in array
	jobjects["valves1"].append({
		"posititon": {"x": 100, "y": 500},
		"name1": "KBAXX",
		"name2": "asdfasdf",
		"rotation": 90,
		#and so on
	})
	print(JSON.stringify(jobjects))
	
	
func flash_link(linkName: String):
	for ch in get_children():
		if ch is FrameLink and ch.self_name == linkName:
			ch.blink()
			break

func swap_frame_cb(frame_name: String, link_name: String):
	frame_swap_called.emit(frame_name, link_name)
	pass

func close_devices_menus():
	for ch in get_children():
		if ch is Device:
			ch.close_menu()

func _on_background_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			close_devices_menus()
	pass # Replace with function body.

func device_menu_popped(dev: Device, status: bool):
	if status:
		#disable other divices
		for ch in get_children():
			if ch is Device and ch != dev:
				ch.menu_active = false
	else:  #activate menus again
		for ch in get_children():
			if ch is Device:
				ch.menu_active = true
				
func devs_cmd_prepared(signals: Dictionary):
	commands_prpared.emit(signals)
