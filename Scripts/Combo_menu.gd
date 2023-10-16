extends Control

var buttonPressedCounter = 0

func _on_button_pressed():
	$HBoxContainer/VBoxContainer/Roles_info.add_role_line(buttonPressedCounter)
	buttonPressedCounter = buttonPressedCounter + 1
	if buttonPressedCounter == 3:
		buttonPressedCounter = 0
