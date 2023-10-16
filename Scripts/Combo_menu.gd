extends Control

var buttonPressedCounter = 0

func _on_button_pressed():
	$HBoxContainer/VBoxContainer/Users_info.add_user_line(buttonPressedCounter)
	buttonPressedCounter = buttonPressedCounter + 1
	if buttonPressedCounter == 4:
		buttonPressedCounter = 0
