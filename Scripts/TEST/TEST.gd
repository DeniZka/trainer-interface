extends Control


var path = "res://Savings/data.json"
var xPositionArray = []
var yPositionArray = []
var sceneNameArray = []
var scenes = {
	"tank" : "res://Scenes/TEST_ELEMENT.tscn"
}


func _on_add_pressed():
	var scene = load(scenes.get("tank")).instantiate()
	add_child(scene)
	var xPosition = $xPosition.text
	var yPosition = $yPosition.text
	scene.position.x = xPosition as float
	scene.position.y = yPosition as float
	xPositionArray.append(xPosition)
	yPositionArray.append(yPosition)
	sceneNameArray.append("tank")


func _on_save_pressed():
	save_scene()

func _on_load_pressed():
	load_scene()

func save_dictionaries():
	var saveDict = {
		"sceneName" : sceneNameArray,
		"xPosition" : xPositionArray,
		"yPosition" : yPositionArray
	}
	return saveDict

func save_scene():
	var saveSceneFile = FileAccess.open(path, FileAccess.WRITE)
	var json_string = JSON.stringify(save_dictionaries())
	saveSceneFile.store_line(json_string)
	saveSceneFile.close()


func load_json_file():
	if not FileAccess.file_exists(path):
		return
	var saveSceneFile = FileAccess.open(path, FileAccess.READ)
	var parsedResult = JSON.parse_string(saveSceneFile.get_as_text())
	if parsedResult is Dictionary:
		return parsedResult
	else:
		print("Error reading file")


func load_scene():
	var data = load_json_file()
	for i in range(data["xPosition"].size()):
		var scene = load(scenes.get(data["sceneName"][i])).instantiate()
		add_child(scene)
		scene.position.x = data["xPosition"][i] as float
		scene.position.y = data["yPosition"][i] as float
	
