extends Node2D

@onready var jobjects : Dictionary = {
	"lines":[], #array of lines
	"valves1":[], 
	"dots":[] 
	#and so on
}

# Called when the node enters the scene tree for the first time.
func _ready():
	#example how to add valve in array
	jobjects["valves1"].append({
		"posititon": {"x": 100, "y": 500},
		"name1": "KBAXX",
		"name2": "asdfasdf",
		"rotation": 90,
		#and so on
	})
	print(JSON.stringify(jobjects))
	pass # Replace with function body.
