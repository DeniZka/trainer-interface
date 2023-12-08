@tool
class_name PopButton extends Node2D

@onready var textColor = $button_place/text
@onready var textButton = $button_place/text/Button
@onready var buttonPlace = $button_place
@onready var player = $anim
@onready var target = $target_point
@onready var backLayer = $button_place/BackLayer
@onready var outline = $button_place/Outline
@onready var overlay = $button_place/Overlay

signal b_pressed()
signal b_pop_done()
signal b_pop_hide()

var tw : Tween

func pop_childs(pop_state):
	for ch in get_children():
		if ch is PopButton:
			ch.pop = pop_state
	pass

@export var text: String = "test":
	set(val):
		if not is_node_ready(): await ready
		text = val
		textButton.text = val

var self_popup_anim_name : String = "popup"
@export var pop : bool = false:
	set(val):
		if not is_node_ready(): await ready
		pop = val
		#search for attached Marker
		for child in get_children():
			if child is Marker2D: #using it as a target pointer
				target.position = child.position
				break
		if val:
			if tw:
				tw.kill()
			tw = create_tween()
			tw.tween_property(buttonPlace, "position", target.position, 0.6)
			tw.play()
			player.play("popup")
			##change animation accorting target position
			#var a : Animation = player.get_animation("temp/" + self_popup_anim_name)
			#a.track_set_key_value(1, 1, target.position)
			#player.play("temp/" + self_popup_anim_name)
		else:
			player.stop()
			buttonPlace.position = Vector2(0, 0)
			emit_signal("b_pop_hide")

@export var text_color : Color = Color(1,1,1,1):
	set(val):
		if not is_node_ready(): await ready
		text_color = val
		textColor.modulate = val

@export var main_color : Color = Color(1,1,1,1):
	set(val):
		if not is_node_ready(): await ready
		main_color = val
		backLayer.modulate = val
		overlay.modulate = val

@export var outline_color : Color = Color(1,1,1,1):
	set(val):
		if not is_node_ready(): await ready
		outline_color = val
		outline.modulate = val

		
		
# Called when the node enters the scene tree for the first time.
func _ready():
	#hide prepare
	buttonPlace.modulate = Color(1,1,1,0)

func _on_button_pressed():
	emit_signal("b_pressed")
	pass # Replace with function body.


func _on_anim_animation_finished(anim_name):
	emit_signal("b_pop_done")
	pass # Replace with function body.
