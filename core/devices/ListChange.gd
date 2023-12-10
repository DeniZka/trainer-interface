@tool 
class_name FrameLink extends Node2D

signal frame_swap_called(frame_name: String, link_name: String)

@onready var shapes = $shapes
@onready var text = $text/name
@onready var textColor = $text

const BLUE_RGB = Color(0, 0.9411764705882353, 1)
const DEFAULT_RGB = Color(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)

@export_category("List Change") 
@export_enum("Вход", "Выход") var mode: String = "Вход":
	set(val):
		mode = val
		if not is_node_ready(): await ready
		if val == "Вход":
			$shapes/ListGap.visible = false
			$shapes/ListChange.visible = true
		else:
			$shapes/ListGap.visible = true
			$shapes/ListChange.visible = false

@export var frame_name: String = "01":
	set(val):
		if not is_node_ready(): await ready
		frame_name = val
		text.text = val + "-" + self_name
		
@export var self_name: String = "A":
	set(val):
		if not is_node_ready(): await ready
		self_name = val
		text.text = frame_name + "-" + val
		
@export_range(-180.0, 180.0, 180.0, "degrees") var rotate: float = 0.0:
	set(val):
		rotate = val
		if not is_node_ready(): await ready
		shapes.rotation_degrees = val

@export var text_color : Color = Color(0,0,0,1):
	set(val):
		if not is_node_ready(): await ready
		text_color = val
		textColor.modulate = val

@export var shape_color : Color = Color(1,1,1,1):
	set(val):
		if not is_node_ready(): await ready
		shape_color = val
		shapes.modulate = val

func blink():
	$anim.play("blink")

func _on_bswap_pressed():
	frame_swap_called.emit(self.frame_name, self.self_name)
