extends Node
class_name ButtonsPaintService

func getLine(key, lineDictionary: Dictionary):
	return lineDictionary[key]

func getButton(key, buttonsDictionary: Dictionary):
	return buttonsDictionary[key]

func paintButtonHorizontal(button: ButtonDto, rgb: CustomRGBDto, lineDictionary: Dictionary):
	if (button.horizontalLine == null):
		return
	var elementsArray = getLine(button.horizontalLine, lineDictionary)
	for element in elementsArray:
		element.color = Color(rgb.red, rgb.green, rgb.blue)

func paintButtonVertical(button: ButtonDto, rgb: CustomRGBDto, lineDictionary: Dictionary):
	if (button.verticalLine == null):
		return
	var elementsArray = getLine(button.verticalLine, lineDictionary)
	for element in elementsArray:
		element.color = Color(rgb.red, rgb.green, rgb.blue)

func paintVerticalRangeOfButtons(firstButton: ButtonDto, lastButton: ButtonDto, rgb: CustomRGBDto, buttonsArray: Array, lineDictionary: Dictionary):
	var startIndex = buttonsArray.find(firstButton)
	var endIndex = buttonsArray.find(lastButton)
	if (startIndex == -1 || endIndex == -1 || startIndex > endIndex):
		return
	var buttonsRange = buttonsArray.slice(startIndex, endIndex + 1)
	for button in buttonsRange:
		paintButtonVertical(button, rgb, lineDictionary)

func paintVerticalRangeOfButtonsWithShift(firstButton: ButtonDto, rgb: CustomRGBDto, buttonsArray: Array, lineDictionary: Dictionary):
	var startIndex = buttonsArray.find(firstButton)
	if (startIndex == -1):
		return
	var buttonsRange = buttonsArray.slice(startIndex + 1, buttonsArray.size())
	for button in buttonsRange:
		paintButtonVertical(button, rgb, lineDictionary)

func getPressedButton(buttonsArray: Array, buttonsDictionary: Dictionary) -> ButtonDto :
	for button in buttonsArray:
		if (getButton(button.button, buttonsDictionary) != null && getButton(button.button, buttonsDictionary) is BaseButton && getButton(button.button, buttonsDictionary).button_pressed):
			return button
	return 

func paintFocusEnteredButtonUnited(button: ButtonDto, pressedColorRGB: CustomRGBDto, lineDictionary: Dictionary, buttonsArray: Array):
	paintButtonHorizontal(buttonsArray[0], pressedColorRGB, lineDictionary)
	paintButtonHorizontal(button, pressedColorRGB, lineDictionary)
	paintVerticalRangeOfButtons(buttonsArray[0], button, pressedColorRGB, buttonsArray, lineDictionary)

func paintFocusExitedButtonUnited(button: ButtonDto, normalColorRGB: CustomRGBDto, lineDictionary: Dictionary, buttonsArray: Array):
	paintButtonHorizontal(buttonsArray[0], normalColorRGB, lineDictionary)
	paintButtonHorizontal(button, normalColorRGB, lineDictionary)
	paintVerticalRangeOfButtons(buttonsArray[0], button, normalColorRGB, buttonsArray, lineDictionary)

func paintMouseEnteredButtonUnited(button: ButtonDto, mouseEnteredColorRGB: CustomRGBDto, lineDictionary: Dictionary, buttonsArray: Array):
	paintButtonHorizontal(buttonsArray[0], mouseEnteredColorRGB, lineDictionary)
	paintButtonHorizontal(button, mouseEnteredColorRGB, lineDictionary)
	paintVerticalRangeOfButtons(buttonsArray[0], button, mouseEnteredColorRGB, buttonsArray, lineDictionary)

func paintMouseExitedButtonUnited(button: ButtonDto, normalColorRGB: CustomRGBDto, pressedColorRGB: CustomRGBDto, lineDictionary: Dictionary, buttonsDictionary: Dictionary, buttonsArray: Array):
	var pressedButton = getPressedButton(buttonsArray, buttonsDictionary)
	if (pressedButton == null):
		paintButtonHorizontal(buttonsArray[0], normalColorRGB, lineDictionary)
		paintButtonHorizontal(button, normalColorRGB, lineDictionary)
		paintVerticalRangeOfButtons(buttonsArray[0], button, normalColorRGB, buttonsArray, lineDictionary)
	elif (pressedButton == button):
		paintButtonHorizontal(buttonsArray[0], pressedColorRGB, lineDictionary)
		paintButtonHorizontal(button, pressedColorRGB, lineDictionary)
		paintVerticalRangeOfButtons(buttonsArray[0], pressedButton, pressedColorRGB, buttonsArray, lineDictionary)
	else:
		paintButtonHorizontal(buttonsArray[0], pressedColorRGB, lineDictionary)
		paintVerticalRangeOfButtons(buttonsArray[0], pressedButton, pressedColorRGB, buttonsArray, lineDictionary)
		paintVerticalRangeOfButtonsWithShift(pressedButton, normalColorRGB, buttonsArray, lineDictionary)
		paintButtonHorizontal(button, normalColorRGB, lineDictionary)

func paintPressedButtonUnited(button: ButtonDto, pressedColorRGB: CustomRGBDto, lineDictionary: Dictionary, buttonsArray: Array):
	paintButtonHorizontal(buttonsArray[0], pressedColorRGB, lineDictionary)
	paintButtonHorizontal(button, pressedColorRGB, lineDictionary)
	paintVerticalRangeOfButtons(buttonsArray[0], button, pressedColorRGB, buttonsArray, lineDictionary)

func paintFocusEnteredButtonSeparated(button: ButtonDto, pressedColorRGB: CustomRGBDto, lineDictionary: Dictionary):
	paintButtonHorizontal(button, pressedColorRGB, lineDictionary)
	paintButtonVertical(button, pressedColorRGB, lineDictionary)

func paintFocusExitedButtonSeparated(button: ButtonDto, normalColorRGB: CustomRGBDto, lineDictionary: Dictionary):
	paintButtonHorizontal(button, normalColorRGB, lineDictionary)
	paintButtonVertical(button, normalColorRGB, lineDictionary)

func paintMouseEnteredButtonSeparated(button: ButtonDto, mouseEnteredColorRGB: CustomRGBDto, lineDictionary: Dictionary):
	paintButtonHorizontal(button, mouseEnteredColorRGB, lineDictionary)
	paintButtonVertical(button, mouseEnteredColorRGB, lineDictionary)

func paintMouseExitedButtonSeparated(button: ButtonDto, normalColorRGB: CustomRGBDto, pressedColorRGB: CustomRGBDto, lineDictionary: Dictionary, buttonsDictionary: Dictionary, buttonsArray: Array):
	var pressedButton = getPressedButton(buttonsArray, buttonsDictionary)
	if (pressedButton == null):
		paintButtonHorizontal(button, normalColorRGB, lineDictionary)
		paintButtonVertical(button, normalColorRGB, lineDictionary)
	elif (pressedButton == button):
		paintButtonHorizontal(button, pressedColorRGB, lineDictionary)
		paintButtonVertical(pressedButton, pressedColorRGB, lineDictionary)
	else:
		paintButtonVertical(button, normalColorRGB, lineDictionary)
		paintButtonHorizontal(button, normalColorRGB, lineDictionary)

func paintPressedButtonSeparated(button: ButtonDto, pressedColorRGB: CustomRGBDto, lineDictionary: Dictionary):
	paintButtonHorizontal(button, pressedColorRGB, lineDictionary)
	paintButtonVertical(button, pressedColorRGB, lineDictionary)
