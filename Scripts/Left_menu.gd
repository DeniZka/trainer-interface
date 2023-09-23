extends Control

@onready var ICONS : Dictionary = {
	"initialization" : "res://Icons/Left_menu/initialization.png",
	"play" : "res://Icons/Left_menu/Play.png",
	"step" : "res://Icons/Left_menu/Step.png",
	"pause" : "res://Icons/Left_menu/Pause.png",
	"stop" : "res://Icons/Left_menu/Stop.png",
	"user" : "res://Icons/Left_menu/User_icon_left_menu.png",
	"role" : "res://Icons/Left_menu/Role_icon_left_menu.png",
	"model" : "res://Icons/Left_menu/Model_icon_left_menu.png",
	"restart" : "res://Icons/Left_menu/Restart_icon_left_menu.png",
	"screen" : "res://Icons/Left_menu/Videoframe_icon_left_menu.png",
	"scenario" : "res://Icons/Left_menu/Scenario_icon_left_menu.png",
	"server" : "res://Icons/Left_menu/ServerS_icon_left_menu.png",
	"system_state" : "res://Icons/Left_menu/System_condition_icon_left_menu.png",
	"single_server" : "res://Icons/Left_menu/Server_icon_left_menu.png",
	"log_out" : "res://Icons/Left_menu/Log_out.png"
}

@onready var CONNECT_LINES : Dictionary = {
	"H_Set" : [$Back/Settings/SetH],
	"H_Log" : [$Back/MainV/Panel_for_login/Login/Login/LogH],
	"V_U" : [$Back/MainV/SettingsH/Left_menu/Users/Users_button/UV],
	"V_R" : [$Back/MainV/SettingsH/Left_menu/Roles/Roles_button/RV],
	"V_M" : [$Back/MainV/SettingsH/Left_menu/Models/Models_button/MV],
	"V_Res" : [$Back/MainV/SettingsH/Left_menu/Restarts/Restarts_button/ResV],
	"V_Scr" : [$Back/MainV/SettingsH/Left_menu/Screens/Screens_button/SV],
	"V_Scen" : [$Back/MainV/SettingsH/Left_menu/Scenarios/Scenarios_button/ScV],
	"V_Ser" : [$Back/MainV/SettingsH/Left_menu/Servers/Servers_button/SerV],
	"V_Sys" : [$Back/MainV/SettingsH/Left_menu/System_condition/System_condition_button/SysV],
	"V_SerS" : [$Back/MainV/Servers_name/Servers/ServersV],
	"V_Ser1" : [$Back/MainV/Servers_HBox/Servers_ScrollBox/Servers/Server1/Server1/Label/SerAV],
	"V_Ser2" : [$Back/MainV/Servers_HBox/Servers_ScrollBox/Servers/Server2/Server2/Label/SerBV],
	"V_Ser3" : [$Back/MainV/Servers_HBox/Servers_ScrollBox/Servers/Server3/Server3/Label/SerVV],
	"H_U" : [$Back/MainV/SettingsH/Left_menu/Users/Users_button/UH],
	"H_R" : [$Back/MainV/SettingsH/Left_menu/Roles/Roles_button/RH],
	"H_M" : [$Back/MainV/SettingsH/Left_menu/Models/Models_button/MH],
	"H_Res" : [$Back/MainV/SettingsH/Left_menu/Restarts/Restarts_button/ResH],
	"H_Scr" : [$Back/MainV/SettingsH/Left_menu/Screens/Screens_button/SH],
	"H_Scen" : [$Back/MainV/SettingsH/Left_menu/Scenarios/Scenarios_button/ScH],
	"H_Ser" : [$Back/MainV/SettingsH/Left_menu/Servers/Servers_button/SerH],
	"H_Sys" : [$Back/MainV/SettingsH/Left_menu/System_condition/System_condition_button/SysH],
	"H_SerS" : [$Back/MainV/Servers_name/Servers/ServersH],
	"H_Ser1" : [$Back/MainV/Servers_HBox/Servers_ScrollBox/Servers/Server1/Server1/Label/SerAH],
	"H_Ser2" : [$Back/MainV/Servers_HBox/Servers_ScrollBox/Servers/Server2/Server2/Label/SerBH],
	"H_Ser3" : [$Back/MainV/Servers_HBox/Servers_ScrollBox/Servers/Server3/Server3/Label/SerVH]
}

@onready var BUTTONS : Dictionary = {
	"Settings" : null,
	"ServerS" : null,
	"Login" : $Back/MainV/Panel_for_login/Login,
	"Users" : $Back/MainV/SettingsH/Left_menu/Users/Users_button,
	"Roles" : $Back/MainV/SettingsH/Left_menu/Roles/Roles_button,
	"Models" : $Back/MainV/SettingsH/Left_menu/Models/Models_button,
	"Restarts" : $Back/MainV/SettingsH/Left_menu/Restarts/Restarts_button,
	"Screens" : $Back/MainV/SettingsH/Left_menu/Screens/Screens_button,
	"Scenarios" : $Back/MainV/SettingsH/Left_menu/Scenarios/Scenarios_button,
	"Servers" : $Back/MainV/SettingsH/Left_menu/Servers/Servers_button,
	"System" : $Back/MainV/SettingsH/Left_menu/System_condition/System_condition_button,
	"Server1" : $Back/MainV/Servers_HBox/Servers_ScrollBox/Servers/Server1/Server1,
	"Server2" : $Back/MainV/Servers_HBox/Servers_ScrollBox/Servers/Server2/Server2,
	"Server3" : $Back/MainV/Servers_HBox/Servers_ScrollBox/Servers/Server3/Server3
}

@onready var BUTTONS_ARRAY : Array = [
	ButtonDto.new("Settings", null, "H_Set"),
	ButtonDto.new("Users", "V_U", "H_U"),
	ButtonDto.new("Roles", "V_R", "H_R"),
	ButtonDto.new("Models", "V_M", "H_M"),
	ButtonDto.new("Restarts", "V_Res", "H_Res"),
	ButtonDto.new("Screens", "V_Scr", "H_Scr"),
	ButtonDto.new("Scenarios", "V_Scen", "H_Scen"),
	ButtonDto.new("Servers", "V_Ser", "H_Ser"),
	ButtonDto.new("System", "V_Sys", "H_Sys")
]

@onready var SERVERS_ARRAY : Array = [
	ButtonDto.new("ServerS", "V_SerS", "H_SerS"),
	ButtonDto.new("Server1", "V_Ser1", "H_Ser1"),
	ButtonDto.new("Server2", "V_Ser2", "H_Ser2"),
	ButtonDto.new("Server3", "V_Ser3", "H_Ser3")
] 

@onready var LOGIN_ARRAY : Array = [
	ButtonDto.new("Login", null, "H_Log")
] 

@onready var leftMenuService: LeftMenuService = LeftMenuService.new(CONNECT_LINES, BUTTONS)

func _on_users_button_focus_entered():
	leftMenuService.paintLeftMenuFocusEnteredButton(BUTTONS_ARRAY[1], BUTTONS_ARRAY)

func _on_users_button_focus_exited():
	leftMenuService.paintLeftMenuFocusExitedButton(BUTTONS_ARRAY[1], BUTTONS_ARRAY)

func _on_users_button_mouse_entered():
	leftMenuService.paintLeftMenuMouseEnteredButton(BUTTONS_ARRAY[1], BUTTONS_ARRAY)

func _on_users_button_mouse_exited():
	leftMenuService.paintLeftMenuMouseExitedButton(BUTTONS_ARRAY[1], BUTTONS_ARRAY)

func _on_users_button_pressed():
	leftMenuService.paintLeftMenuPressedButton(BUTTONS_ARRAY[1], BUTTONS_ARRAY)



func _on_roles_button_focus_entered():
	leftMenuService.paintLeftMenuFocusEnteredButton(BUTTONS_ARRAY[2], BUTTONS_ARRAY)

func _on_roles_button_focus_exited():
	leftMenuService.paintLeftMenuFocusExitedButton(BUTTONS_ARRAY[2], BUTTONS_ARRAY)

func _on_roles_button_mouse_entered():
	leftMenuService.paintLeftMenuMouseEnteredButton(BUTTONS_ARRAY[2], BUTTONS_ARRAY)

func _on_roles_button_mouse_exited():
	leftMenuService.paintLeftMenuMouseExitedButton(BUTTONS_ARRAY[2], BUTTONS_ARRAY)

func _on_roles_button_pressed():
	leftMenuService.paintLeftMenuPressedButton(BUTTONS_ARRAY[2], BUTTONS_ARRAY)



func _on_models_button_focus_entered():
	leftMenuService.paintLeftMenuFocusEnteredButton(BUTTONS_ARRAY[3], BUTTONS_ARRAY)

func _on_models_button_focus_exited():
	leftMenuService.paintLeftMenuFocusExitedButton(BUTTONS_ARRAY[3], BUTTONS_ARRAY)

func _on_models_button_mouse_entered():
	leftMenuService.paintLeftMenuMouseEnteredButton(BUTTONS_ARRAY[3], BUTTONS_ARRAY)

func _on_models_button_mouse_exited():
	leftMenuService.paintLeftMenuMouseExitedButton(BUTTONS_ARRAY[3], BUTTONS_ARRAY)

func _on_models_button_pressed():
	leftMenuService.paintLeftMenuPressedButton(BUTTONS_ARRAY[3], BUTTONS_ARRAY)



func _on_restarts_button_focus_entered():
	leftMenuService.paintLeftMenuFocusEnteredButton(BUTTONS_ARRAY[4], BUTTONS_ARRAY)

func _on_restarts_button_focus_exited(): 
	leftMenuService.paintLeftMenuFocusExitedButton(BUTTONS_ARRAY[4], BUTTONS_ARRAY)

func _on_restarts_button_mouse_entered():
	leftMenuService.paintLeftMenuMouseEnteredButton(BUTTONS_ARRAY[4], BUTTONS_ARRAY)

func _on_restarts_button_mouse_exited():
	leftMenuService.paintLeftMenuMouseExitedButton(BUTTONS_ARRAY[4], BUTTONS_ARRAY)

func _on_restarts_button_pressed():
	leftMenuService.paintLeftMenuPressedButton(BUTTONS_ARRAY[4], BUTTONS_ARRAY)



func _on_screens_button_focus_entered():
	leftMenuService.paintLeftMenuFocusEnteredButton(BUTTONS_ARRAY[5], BUTTONS_ARRAY)

func _on_screens_button_focus_exited():
	leftMenuService.paintLeftMenuFocusExitedButton(BUTTONS_ARRAY[5], BUTTONS_ARRAY)

func _on_screens_button_mouse_entered():
	leftMenuService.paintLeftMenuMouseEnteredButton(BUTTONS_ARRAY[5], BUTTONS_ARRAY)

func _on_screens_button_mouse_exited():
	leftMenuService.paintLeftMenuMouseExitedButton(BUTTONS_ARRAY[5], BUTTONS_ARRAY)

func _on_screens_button_pressed():
	leftMenuService.paintLeftMenuPressedButton(BUTTONS_ARRAY[5], BUTTONS_ARRAY)



func _on_scenarios_button_focus_entered():
	leftMenuService.paintLeftMenuFocusEnteredButton(BUTTONS_ARRAY[6], BUTTONS_ARRAY)

func _on_scenarios_button_focus_exited():
	leftMenuService.paintLeftMenuFocusExitedButton(BUTTONS_ARRAY[6], BUTTONS_ARRAY)

func _on_scenarios_button_mouse_entered():
	leftMenuService.paintLeftMenuMouseEnteredButton(BUTTONS_ARRAY[6], BUTTONS_ARRAY)

func _on_scenarios_button_mouse_exited():
	leftMenuService.paintLeftMenuMouseExitedButton(BUTTONS_ARRAY[6], BUTTONS_ARRAY)

func _on_scenarios_button_pressed():
	leftMenuService.paintLeftMenuPressedButton(BUTTONS_ARRAY[6], BUTTONS_ARRAY)



func _on_servers_button_focus_entered():
	leftMenuService.paintLeftMenuFocusEnteredButton(BUTTONS_ARRAY[7], BUTTONS_ARRAY)

func _on_servers_button_focus_exited():
	leftMenuService.paintLeftMenuFocusExitedButton(BUTTONS_ARRAY[7], BUTTONS_ARRAY)

func _on_servers_button_mouse_entered():
	leftMenuService.paintLeftMenuMouseEnteredButton(BUTTONS_ARRAY[7], BUTTONS_ARRAY)

func _on_servers_button_mouse_exited():
	leftMenuService.paintLeftMenuMouseExitedButton(BUTTONS_ARRAY[7], BUTTONS_ARRAY)

func _on_servers_button_pressed():
	leftMenuService.paintLeftMenuPressedButton(BUTTONS_ARRAY[7], BUTTONS_ARRAY)



func _on_system_condition_button_focus_entered():
	leftMenuService.paintLeftMenuFocusEnteredButton(BUTTONS_ARRAY[8], BUTTONS_ARRAY)

func _on_system_condition_button_focus_exited():
	leftMenuService.paintLeftMenuFocusExitedButton(BUTTONS_ARRAY[8], BUTTONS_ARRAY)

func _on_system_condition_button_mouse_entered():
	leftMenuService.paintLeftMenuMouseEnteredButton(BUTTONS_ARRAY[8], BUTTONS_ARRAY)

func _on_system_condition_button_mouse_exited():
	leftMenuService.paintLeftMenuMouseExitedButton(BUTTONS_ARRAY[8], BUTTONS_ARRAY)

func _on_system_condition_button_pressed():
	leftMenuService.paintLeftMenuPressedButton(BUTTONS_ARRAY[8], BUTTONS_ARRAY)





func _on_server_1_focus_entered():
	leftMenuService.paintLeftMenuFocusEnteredButton(SERVERS_ARRAY[1], SERVERS_ARRAY)

func _on_server_1_focus_exited():
	leftMenuService.paintLeftMenuFocusExitedButton(SERVERS_ARRAY[1], SERVERS_ARRAY)

func _on_server_1_mouse_entered():
	leftMenuService.paintLeftMenuMouseEnteredButton(SERVERS_ARRAY[1], SERVERS_ARRAY)

func _on_server_1_mouse_exited():
	leftMenuService.paintLeftMenuMouseExitedButton(SERVERS_ARRAY[1], SERVERS_ARRAY)

func _on_server_1_pressed():
	leftMenuService.paintLeftMenuPressedButton(SERVERS_ARRAY[1], SERVERS_ARRAY)



func _on_server_2_focus_entered():
	leftMenuService.paintLeftMenuFocusEnteredButton(SERVERS_ARRAY[2], SERVERS_ARRAY)

func _on_server_2_focus_exited():
	leftMenuService.paintLeftMenuFocusExitedButton(SERVERS_ARRAY[2], SERVERS_ARRAY)

func _on_server_2_mouse_entered():
	leftMenuService.paintLeftMenuMouseEnteredButton(SERVERS_ARRAY[2], SERVERS_ARRAY)

func _on_server_2_mouse_exited():
	leftMenuService.paintLeftMenuMouseExitedButton(SERVERS_ARRAY[2], SERVERS_ARRAY)

func _on_server_2_pressed():
	leftMenuService.paintLeftMenuPressedButton(SERVERS_ARRAY[2], SERVERS_ARRAY)


func _on_server_3_focus_entered():
	leftMenuService.paintLeftMenuFocusEnteredButton(SERVERS_ARRAY[3], SERVERS_ARRAY)

func _on_server_3_focus_exited():
	leftMenuService.paintLeftMenuFocusExitedButton(SERVERS_ARRAY[3], SERVERS_ARRAY)

func _on_server_3_mouse_entered():
	leftMenuService.paintLeftMenuMouseEnteredButton(SERVERS_ARRAY[3], SERVERS_ARRAY)

func _on_server_3_mouse_exited():
	leftMenuService.paintLeftMenuMouseExitedButton(SERVERS_ARRAY[3], SERVERS_ARRAY)

func _on_server_3_pressed():
	leftMenuService.paintLeftMenuPressedButton(SERVERS_ARRAY[3], SERVERS_ARRAY)



func _on_login_focus_entered():
	leftMenuService.paintLoginFocusEnteredButton(LOGIN_ARRAY[0])

func _on_login_focus_exited():
	leftMenuService.paintLoginFocusExitedButton(LOGIN_ARRAY[0])

func _on_login_mouse_entered():
	leftMenuService.paintLoginMouseEnteredButton(LOGIN_ARRAY[0])

func _on_login_mouse_exited():
	leftMenuService.paintLoginMouseExitedButton(LOGIN_ARRAY[0], LOGIN_ARRAY)

func _on_login_pressed():
	leftMenuService.paintLoginPressedButton(LOGIN_ARRAY[0])
