class_name DeviceAddonInfo
extends Label

@export var signal_name : String = "XQ1"

@export var prefix : String = "Data:"
@export var suffix : String = "kind"

var pre_val : float = -1.0

func _ready():
	process_signal([0.0])

func process_signal(value: Array):
	if pre_val == float(value[0]):
		return
	pre_val = value[0]
	self.text = "%s %.2f %s" % [prefix, pre_val, suffix]
