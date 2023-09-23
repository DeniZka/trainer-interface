extends Node
class_name LeftMenuService

func _init(_CONNECT_LINES : Dictionary, _BUTTONS : Dictionary):
	CONNECT_LINES = _CONNECT_LINES
	BUTTONS = _BUTTONS

var WHITE_RGB = CustomRGBDto.new(1, 1, 1)
var LEFTMENU_DARK_BLUE_RGB = CustomRGBDto.new(0.4, 0.4862745098039216, 0.5568627450980392)
var LEFTMENU_LIGHT_BLUE_RGB = CustomRGBDto.new(0.6, 0.6588235294117647, 0.7058823529411765)

var CONNECT_LINES : Dictionary 

var BUTTONS : Dictionary 

var buttonsPaintService : ButtonsPaintService = ButtonsPaintService.new()

func paintLeftMenuFocusEnteredButton(button: ButtonDto, buttonsArray: Array):
	buttonsPaintService.paintFocusEnteredButtonUnited(button, WHITE_RGB, CONNECT_LINES, buttonsArray)

func paintLeftMenuFocusExitedButton(button: ButtonDto, buttonsArray: Array):
	buttonsPaintService.paintFocusExitedButtonUnited(button, LEFTMENU_DARK_BLUE_RGB, CONNECT_LINES, buttonsArray)

func paintLeftMenuMouseEnteredButton(button: ButtonDto, buttonsArray: Array):
	buttonsPaintService.paintMouseEnteredButtonUnited(button, LEFTMENU_LIGHT_BLUE_RGB, CONNECT_LINES, buttonsArray)

func paintLeftMenuMouseExitedButton(button: ButtonDto, buttonsArray: Array):
	buttonsPaintService.paintMouseExitedButtonUnited(button, LEFTMENU_DARK_BLUE_RGB, WHITE_RGB, CONNECT_LINES, BUTTONS, buttonsArray)

func paintLeftMenuPressedButton(button: ButtonDto, buttonsArray: Array):
	buttonsPaintService.paintPressedButtonUnited(button, WHITE_RGB, CONNECT_LINES, buttonsArray)

func paintLoginFocusEnteredButton(button: ButtonDto):
	buttonsPaintService.paintFocusEnteredButtonSeparated(button, WHITE_RGB, CONNECT_LINES)

func paintLoginFocusExitedButton(button: ButtonDto):
	buttonsPaintService.paintFocusExitedButtonSeparated(button, LEFTMENU_DARK_BLUE_RGB, CONNECT_LINES)

func paintLoginMouseEnteredButton(button: ButtonDto):
	buttonsPaintService.paintMouseEnteredButtonSeparated(button, LEFTMENU_LIGHT_BLUE_RGB, CONNECT_LINES)

func paintLoginMouseExitedButton(button: ButtonDto, buttonsArray: Array):
	buttonsPaintService.paintMouseExitedButtonSeparated(button, LEFTMENU_DARK_BLUE_RGB, WHITE_RGB, CONNECT_LINES, BUTTONS, buttonsArray)

func paintLoginPressedButton(button: ButtonDto):
	buttonsPaintService.paintPressedButtonSeparated(button, WHITE_RGB, CONNECT_LINES)
