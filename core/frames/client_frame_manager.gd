extends Node

#FIXME: replace nodes frame managers with real client nodes
@onready var nodes = [$frame_manager, $frame_manager2]

var cli_signals : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for n in nodes:
		var fm: FrameManager
		var node_sl : Array = n.get_request_signal_list()
		for node_s in node_sl:
			cli_signals
		
		pass
	pass # Replace with function body.




#dummy stuff
func _on_option_button_item_selected(index):
	for i in range(nodes.size()):
		if i == index:
			nodes[i].visible = true
		else:
			nodes[i].visible = false
	pass # Replace with function body.
