extends Node
class_name UpperMenuService

func _init(_CONNECT_LINES : Dictionary, _BUTTONS : Dictionary):
	CONNECT_LINES = _CONNECT_LINES
	BUTTONS = _BUTTONS

var UPMENU_DARK_BLUE_RGB = CustomRGBDto.new(0.1019607843137255, 0.1607843137254902, 0.2117647058823529)
var UPMENU_LIGHT_BLUE_RGB = CustomRGBDto.new(0.5490196078431373, 0.5764705882352941, 0.603921568627451)
var RIGHTMENU_LIGHT_RED_RGB = CustomRGBDto.new(0.6196078431372549, 0.4980392156862745, 0.4980392156862745)
var RIGHTMENU_DARK_RED_RGB = CustomRGBDto.new(0.2431372549019608, 0.003921568627451, 0.003921568627451)

var CONNECT_LINES : Dictionary 

var BUTTONS : Dictionary 

var buttonsPaintService : ButtonsPaintService = ButtonsPaintService.new()

func paintUpperMenuFocusEnteredButton(button: ButtonDto):
	buttonsPaintService.paintFocusEnteredButtonSeparated(button, UPMENU_DARK_BLUE_RGB, CONNECT_LINES)

func paintUpperMenuFocusExitedButton(button: ButtonDto):
	buttonsPaintService.paintFocusExitedButtonSeparated(button, UPMENU_LIGHT_BLUE_RGB, CONNECT_LINES)
