extends Node

func _ready() -> void:
	var results = await Api.saves.get_saves(1, 25)
	for result in results:
		print(result)
