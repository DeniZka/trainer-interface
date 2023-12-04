@tool
extends Node2D


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
			$mplay.play("popup")
		else:
			$mplay.stop()
		self.pop_chids(val)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	if not is_node_ready(): await  ready
	self.pop = not self.pop
	pass # Replace with function body.




func _on_node_2d_2_b_pressed():
	for ch in $"and-me"/Marker2D.get_children():
		if ch is PopButton:
			ch.pop = not ch.pop
	pass # Replace with function body.


func _on_node_2d_2_b_pop_done():
	for ch in $"and-me"/Marker2D.get_children():
		if ch is PopButton:
			ch.pop = true
	pass # Replace with function body.


func _on_node_2d_2_b_pop_hide():
	for ch in $"and-me"/Marker2D.get_children():
		if ch is PopButton:
			ch.pop = false
	pass # Replace with function body.
