class_name FrameManager
extends Node2D

signal exit_called() #emit when user wants to exit system

@onready var nframes = $frames
@onready var dummy = $dummy_frame

#FIXME REMOVE
@onready var KVA1 = $frames/kva_scene
@onready var KVA2 = $frames/KBA2

func _ready():
	#TODO: parse frames save files and load them
	#FIXME: then rework this a bit
	for ch in nframes.get_children():
		if ch is Frame:
			ch.frame_swap_called.connect(swap_frame_cb)

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
