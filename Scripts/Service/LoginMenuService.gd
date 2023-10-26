extends Node
class_name LoginMenuService

func _init(_CONNECT_LINES : Dictionary, _BUTTONS : Dictionary):
	CONNECT_LINES = _CONNECT_LINES
	BUTTONS = _BUTTONS

var LOGINMENU_WHITE_RGB = CustomRGBDto.new(1, 1, 1)
var LOGINMENU_LIGHT_BLUE_RGB = CustomRGBDto.new(0.5490196078431373, 0.607843137254902, 0.6588235294117647)

var CONNECT_LINES : Dictionary 

var BUTTONS : Dictionary 

var buttonsPaintService : ButtonsPaintService = ButtonsPaintService.new()

func paintLoginMenuFocusEnteredButton(button: ButtonDto):
	buttonsPaintService.paintFocusEnteredButtonSeparated(button, LOGINMENU_WHITE_RGB, CONNECT_LINES)

func paintLoginMenuFocusExitedButton(button: ButtonDto):
	buttonsPaintService.paintFocusExitedButtonSeparated(button, LOGINMENU_LIGHT_BLUE_RGB, CONNECT_LINES)

func paintLoginMenuMouseEnteredButton(button: ButtonDto):
	buttonsPaintService.paintMouseEnteredButtonSeparated(button, LOGINMENU_WHITE_RGB, CONNECT_LINES)

func paintLoginMenuMouseExitedButton(button: ButtonDto, buttonsArray: Array):
	buttonsPaintService.paintMouseExitedButtonSeparated(button, LOGINMENU_LIGHT_BLUE_RGB, LOGINMENU_WHITE_RGB, CONNECT_LINES, BUTTONS, buttonsArray)

func paintLoginMenuPressedButton(button: ButtonDto):
	buttonsPaintService.paintPressedButtonSeparated(button, LOGINMENU_WHITE_RGB, CONNECT_LINES)
