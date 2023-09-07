extends Control
@onready var icons : Dictionary = {
	"initialization" : "res://Icons/Left_menu/initialization.png",
	"play" : "res://Icons/Left_menu/Play.png",
	"step" : "res://Icons/Left_menu/Step.png",
	"pause" : "res://Icons/Left_menu/Pause.png",
	"stop" : "res://Icons/Left_menu/Stop.png",
	"user_icon" : "res://Icons/Left_menu/User_icon_left_menu.png",
	"role_icon" : "res://Icons/Left_menu/Role_icon_left_menu.png",
	"model_icon" : "res://Icons/Left_menu/Model_icon_left_menu.png",
	"restart_icon" : "res://Icons/Left_menu/Restart_icon_left_menu.png",
	"screen_icon" : "res://Icons/Left_menu/Videoframe_icon_left_menu.png",
	"scenario_icon" : "res://Icons/Left_menu/Scenario_icon_left_menu.png",
	"server_icon" : "res://Icons/Left_menu/ServerS_icon_left_menu.png",
	"system_state_icon" : "res://Icons/Left_menu/System_condition_icon_left_menu.png",
	"single_server_icon" : "res://Icons/Left_menu/Server_icon_left_menu.png",
	"log_out_icon" : "res://Icons/Left_menu/Log_out.png"
}
@onready var setconn = $Back/Settings/SetH
@onready var UVconn = $Back/MainV/SettingsH/Left_menu/Users/Users_button/UV
@onready var UHconn = $Back/MainV/SettingsH/Left_menu/Users/Users_button/UH
@onready var RVconn = $Back/MainV/SettingsH/Left_menu/Roles/Roles_button/RV
@onready var RHconn = $Back/MainV/SettingsH/Left_menu/Roles/Roles_button/RH
@onready var MVconn = $Back/MainV/SettingsH/Left_menu/Models/Models_button/MV
@onready var MHconn = $Back/MainV/SettingsH/Left_menu/Models/Models_button/MH
@onready var ResVconn = $Back/MainV/SettingsH/Left_menu/Restarts/Restarts_button/ResV
@onready var ResHconn = $Back/MainV/SettingsH/Left_menu/Restarts/Restarts_button/ResH
@onready var SVconn = $Back/MainV/SettingsH/Left_menu/Screens/Screens_button/SV
@onready var SHconn = $Back/MainV/SettingsH/Left_menu/Screens/Screens_button/SH
@onready var ScVconn = $Back/MainV/SettingsH/Left_menu/Scenarios/Scenarios_button/ScV
@onready var ScHconn = $Back/MainV/SettingsH/Left_menu/Scenarios/Scenarios_button/ScH
@onready var SerVconn = $Back/MainV/SettingsH/Left_menu/Servers/Servers_button/SerV
@onready var SerHconn = $Back/MainV/SettingsH/Left_menu/Servers/Servers_button/SerH
@onready var SysVconn = $Back/MainV/SettingsH/Left_menu/System_condition/System_condition_button/SysV
@onready var SysHconn = $Back/MainV/SettingsH/Left_menu/System_condition/System_condition_button/SysH
@onready var Users_button = $Back/MainV/SettingsH/Left_menu/Users/Users_button

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func _on_users_button_focus_entered():
	setconn.color = Color(1, 1, 1)
	UVconn.color = Color(1, 1, 1)
	UHconn.color = Color(1, 1, 1)
	pass # Replace with function body.
	


func _on_users_button_mouse_entered():
	setconn.color = Color(0.6, 0.6588235294117647, 0.7058823529411765)
	UVconn.color = Color(0.6, 0.6588235294117647, 0.7058823529411765)
	UHconn.color = Color(0.6, 0.6588235294117647, 0.7058823529411765)
	pass # Replace with function body.

func _on_users_button_mouse_exited():
	if (Users_button.button_pressed):
		setconn.color = Color(1, 1, 1)
		UVconn.color = Color(1, 1, 1)
		UHconn.color = Color(1, 1, 1)
	else:
		setconn.color = Color(0.4, 0.4862745098039216, 0.5568627450980392)
		UVconn.color = Color(0.4, 0.4862745098039216, 0.5568627450980392)
		UHconn.color = Color(0.4, 0.4862745098039216, 0.5568627450980392)
	pass # Replace with function body.



func _on_users_button_pressed():
	setconn.color = Color(1, 1, 1)
	UVconn.color = Color(1, 1, 1)
	UHconn.color = Color(1, 1, 1)
	pass # Replace with function body.
	
