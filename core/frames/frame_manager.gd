class_name FrameManager
extends Node2D

signal exit_called() #emit when user wants to exit system

@onready var nframes = $frames
@onready var dummy = $dummy_frame

#fixme remove
var _frms_ = ["res://core/frames/KBA1.tscn", "res://core/frames/KBA2.tscn"]

func _ready():
	#FIXME: cant load float button cause of themed button
	var adf = load("res://core/devices/menus/test1.tscn",)
	print_debug("hello")
	#for f in _frms_:
	#	var scn = load("res://core/devices/menus/mainCircle.tscn")
	#	var sc_templ = load("res://core/frames/KBA1.tscn")
	#	var frame : Frame = sc_templ.instance()
	#	frame.visible = false
	#	nframes.add_child(frame)
	#TODO: parse frames save files and load them
	#FIXME: then rework this a bit
	for ch in nframes.get_children():
		if ch is Frame:
			ch.frame_swap_called.connect(swap_frame_cb)
			ch.commands_prpared.connect(frame_cmd_prepared)

func swap_frame_cb(frameName: String, linkName: String):
	for ch in nframes.get_children():
		ch.visible = false
		if ch is Frame and ch.frame_name == frameName:
			ch.visible = true
			ch.flash_link(linkName)

func _on_exit_pressed():
	for ch in nframes.get_children():
		if ch is Frame:
			ch.visible = false
	dummy.visible = true
	exit_called.emit()

func enter_frame(frame_name: String):
	for ch in nframes.get_children():
		if ch is Frame and ch.frame_name == frame_name:
			ch.visible = true
			dummy.visible = false

func _on_button_pressed():
	enter_frame("01")

func _on_button_2_pressed():
	enter_frame("02")

#------SIG-SIGNAL-SYSTEM
func frame_cmd_prepared(signals: Dictionary):
	#TODO: SEND COMMAND TO DREW SYSEM
	pass
