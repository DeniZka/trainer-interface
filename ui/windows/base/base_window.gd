class_name BaseWindow
extends Control

func open() -> void:
	Log.trace("Открыл окно %s" % name)
	show()

func close() -> void:
	Log.trace("Закрыл окно %s" % name)
	hide()
