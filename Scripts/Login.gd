extends Node

@onready var CONNECT_LINES : Dictionary = {
	"H_LoginAndPassword" : [$Photo_Login/Login/Login/SubText/Subtext/Connecton_HL, $Photo_Login/Login/Login/SubText/Subtext/Connection_HS],
	"V_LoginAndPassword" : [$Photo_Login/Login/Login/SubText/Subtext/Connection_V],
	"H_Entrence" : [$Photo_Login/Login/Login/Enterence/Button/Connection_H],
	"V_Entrence" : [$Photo_Login/Login/Login/Enterence/Button/Connection_V]
}

@onready var BUTTONS : Dictionary = {
	"Login" : $Photo_Login/Login/Login/Login_password/Login_password/Login,
	"Password" : $Photo_Login/Login/Login/Login_password/Login_password/Password,
	"Entrence" : $Photo_Login/Login/Login/Enterence/Button
}

@onready var BUTTONS_ARRAY : Array = [
	ButtonDto.new("Login", "V_LoginAndPassword", "H_LoginAndPassword"),
	ButtonDto.new("Password", "V_LoginAndPassword", "H_LoginAndPassword"),
	ButtonDto.new("Entrence", "V_Entrence", "H_Entrence")
]

@onready var loginMenuService: LoginMenuService = LoginMenuService.new(CONNECT_LINES, BUTTONS)



func _on_login_focus_entered():
	loginMenuService.paintLoginMenuFocusEnteredButton(BUTTONS_ARRAY[0])

func _on_login_focus_exited():
	loginMenuService.paintLoginMenuFocusExitedButton(BUTTONS_ARRAY[0])



func _on_password_focus_entered():
	loginMenuService.paintLoginMenuFocusEnteredButton(BUTTONS_ARRAY[1])

func _on_password_focus_exited():
	loginMenuService.paintLoginMenuFocusExitedButton(BUTTONS_ARRAY[1])



func _on_button_focus_entered():
	loginMenuService.paintLoginMenuFocusEnteredButton(BUTTONS_ARRAY[2])

func _on_button_focus_exited():
	loginMenuService.paintLoginMenuFocusExitedButton(BUTTONS_ARRAY[2])

func _on_button_mouse_entered():
	loginMenuService.paintLoginMenuMouseEnteredButton(BUTTONS_ARRAY[2])

func _on_button_mouse_exited():
	loginMenuService.paintLoginMenuMouseExitedButton(BUTTONS_ARRAY[2], BUTTONS_ARRAY)

func _on_button_pressed():
	loginMenuService.paintLoginMenuPressedButton(BUTTONS_ARRAY[2])
