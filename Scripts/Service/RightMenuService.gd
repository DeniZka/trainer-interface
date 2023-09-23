extends Node
class_name RightMenuService

func _init(_CONNECT_LINES : Dictionary, _BUTTONS : Dictionary):
	CONNECT_LINES = _CONNECT_LINES
	BUTTONS = _BUTTONS

var RIGHTMENU_DARK_BLUE_RGB = CustomRGBDto.new(0.1019607843137255, 0.1607843137254902, 0.2117647058823529)
var RIGHTMENU_LIGHT_BLUE_RGB = CustomRGBDto.new(0.5490196078431373, 0.5764705882352941, 0.603921568627451)
var RIGHTMENU_LIGHT_RED_RGB = CustomRGBDto.new(0.6196078431372549, 0.4980392156862745, 0.4980392156862745)
var RIGHTMENU_DARK_RED_RGB = CustomRGBDto.new(0.2431372549019608, 0.003921568627451, 0.003921568627451)

var CONNECT_LINES : Dictionary 

var BUTTONS : Dictionary 

var buttonsPaintService : ButtonsPaintService = ButtonsPaintService.new()

func paintRightMenuFocusEnteredButton(button: ButtonDto):
	buttonsPaintService.paintFocusEnteredButtonSeparated(button, RIGHTMENU_DARK_BLUE_RGB, CONNECT_LINES)

func paintRightMenuFocusExitedButton(button: ButtonDto):
	buttonsPaintService.paintFocusExitedButtonSeparated(button, RIGHTMENU_LIGHT_BLUE_RGB, CONNECT_LINES)

func paintRightMenuMouseEnteredButton(button: ButtonDto):
	buttonsPaintService.paintMouseEnteredButtonSeparated(button, RIGHTMENU_DARK_BLUE_RGB, CONNECT_LINES)

func paintRightMenuMouseExitedButton(button: ButtonDto, buttonsArray: Array):
	buttonsPaintService.paintMouseExitedButtonSeparated(button, RIGHTMENU_LIGHT_BLUE_RGB, RIGHTMENU_DARK_BLUE_RGB, CONNECT_LINES, BUTTONS, buttonsArray)

func paintRightMenuPressedButton(button: ButtonDto):
	buttonsPaintService.paintPressedButtonSeparated(button, RIGHTMENU_DARK_BLUE_RGB, CONNECT_LINES)



func paintRightMenuDeleteFocusEnteredButton(button: ButtonDto):
	buttonsPaintService.paintFocusEnteredButtonSeparated(button, RIGHTMENU_DARK_RED_RGB, CONNECT_LINES)

func paintRightMenuDeleteFocusExitedButton(button: ButtonDto):
	buttonsPaintService.paintFocusExitedButtonSeparated(button, RIGHTMENU_LIGHT_RED_RGB, CONNECT_LINES)

func paintRightMenuDeleteMouseEnteredButton(button: ButtonDto):
	buttonsPaintService.paintMouseEnteredButtonSeparated(button, RIGHTMENU_DARK_RED_RGB, CONNECT_LINES)

func paintRightMenuDeleteMouseExitedButton(button: ButtonDto, buttonsArray: Array):
	buttonsPaintService.paintMouseExitedButtonSeparated(button, RIGHTMENU_LIGHT_RED_RGB, RIGHTMENU_DARK_RED_RGB, CONNECT_LINES, BUTTONS, buttonsArray)

func paintRightMenuDeletePressedButton(button: ButtonDto):
	buttonsPaintService.paintPressedButtonSeparated(button, RIGHTMENU_DARK_RED_RGB, CONNECT_LINES)
