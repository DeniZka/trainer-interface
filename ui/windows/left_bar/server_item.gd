class_name ServerItem
extends BoxContainer

@onready var label: Label = $"Server Button/Label" as Label

var server_name: String : 
	set(value): 
		server_name = value
		$"Server Button/Label".text = value
		get_line_item().tag = server_name

func get_line_item() -> LineItem:
	return $"Server Button" as LineItem
