class_name FileUploader
extends Control

signal uploaded(file_name: String, file_type: String, base64_data: String)

var file_access: FileAccessWeb

## Desktop temporary file manager
@onready var file_dialog: FileDialog = $FileDialog as FileDialog
@onready var background_panel: Control = $Panel as Control

func _ready() -> void:
	if _is_web():
		file_access = FileAccessWeb.new()
		file_access.loaded.connect(_on_file_loaded)
	else:
		file_dialog.file_selected.connect(_on_desktop_file_selected)
		file_dialog.close_requested.connect(_close_desktop_file_manager)

func open(accept_files: String = "*") -> void:
	if _is_web():
		file_access.open(accept_files)
	else:
		_open_desktop_file_manager()

func _is_web() -> bool:
	return OS.get_name() == "Web"

func _open_desktop_file_manager() -> void:
	background_panel.show()
	file_dialog.show()

func _close_desktop_file_manager() -> void:
	background_panel.hide()
	file_dialog.hide()

func _on_file_loaded(file_name: String, file_type: String, base64_data: String) -> void:
	uploaded.emit(file_name, file_type, base64_data)

func _on_desktop_file_selected(path: String) -> void:
	var file: PackedByteArray = FileAccess.get_file_as_bytes(path)
	var base64: String = Marshalls.raw_to_base64(file)
	var file_name: String = path.get_file()
	uploaded.emit(file_name, file_name.get_extension(), base64)
	_close_desktop_file_manager()
