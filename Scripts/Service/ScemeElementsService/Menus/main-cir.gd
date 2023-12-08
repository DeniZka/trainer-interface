@tool
extends Node2D

signal popped(state: bool)

@onready var player = $mplay
@onready var mainBG = $body/Main_bak
@onready var outline = $body/Main_outline
@onready var mainTop = $body/Maint_top

func pop_chids(pop_state):
	for ch in get_children():
		if ch is PopButton:
			ch.pop = pop
	pass

@export var pop: bool = false:
	set(val):
		if not is_node_ready(): await  ready
		pop = val
		if val:
			player.play("popup")
		else:
			player.stop()
		self.pop_chids(val)

@export var main_color : Color = Color(1,1,1,1):
	set(val):
		if not is_node_ready(): await ready
		main_color = val
		mainBG.modulate = val
		mainTop.modulate = val

@export var outline_color : Color = Color(1,1,1,1):
	set(val):
		if not is_node_ready(): await ready
		outline_color = val
		outline.modulate = val

func _on_button_pressed():
	if not is_node_ready(): await  ready
	self.pop = not self.pop
	emit_signal("popped", self.pop)
	pass # Replace with function body.



func _on_node_2d_2_b_pressed():
	for ch in $"main-cir/refusal/Marker2D".get_children():
		if ch is PopButton:
			ch.pop = not ch.pop
	pass # Replace with function body.


func _on_node_2d_2_b_pop_done():
	for ch in $"main-cir/refusal/Marker2D".get_children():
		if ch is PopButton:
			ch.pop = true
	pass # Replace with function body.


func _on_node_2d_2_b_pop_hide():
	for ch in $"main-cir/refusal/Marker2D".get_children():
		if ch is PopButton:
			ch.pop = false
	pass # Replace with function body.



