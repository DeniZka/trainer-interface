extends Node

@onready var dialog: FileDialog = $FileDialog as FileDialog

func _ready() -> void:
	
	#var model = Model.new()
	#var result = await Api.models.create_model(model)
	dialog.file_selected.connect(_on_file_selected)
	var response = await Api.models.download_file(1)
	print(response)

func _on_file_selected(path: String) -> void:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var data = file.get_buffer(file.get_length())
	print(data)
	var base64 = Marshalls.raw_to_base64(data)
	file.close()
	#await upload_file(1, Api.models, base64)

func upload_file(model_id: int, service: ModelsApiService, file_base64: String) -> void:
	var response = await service.upload_file(model_id, "model_file", "application/zip", file_base64)
	print(response)
