extends Control
@onready var settings_tree = $"HBoxContainer/Panel/VBoxContainer/Settings_tree"
@onready var servers_tree = $"HBoxContainer/Panel/VBoxContainer/Servers_tree"
@onready var login_tree = $"HBoxContainer/Panel/VBoxContainer/Login_tree"

@onready var icons : Dictionary = {
	"server_state" : {
		"initialization" : "res://Icons/Left_menu/initialization.png",
		"play" : "res://Icons/Left_menu/Play.png",
		"step" : "res://Icons/Left_menu/Step.png",
		"pause" : "res://Icons/Left_menu/Pause.png",
		"stop" : "res://Icons/Left_menu/Stop.png"
	},
	"section_settings" : {
		"user_icon" : "res://Icons/Left_menu/User_icon_left_menu.png",
		"role_icon" : "res://Icons/Left_menu/Role_icon_left_menu.png",
		"model_icon" : "res://Icons/Left_menu/Model_icon_left_menu.png",
		"restart_icon" : "res://Icons/Left_menu/Restart_icon_left_menu.png",
		"screen_icon" : "res://Icons/Left_menu/Videoframe_icon_left_menu.png",
		"scenario_icon" : "res://Icons/Left_menu/Scenario_icon_left_menu.png",
		"server_icon" : "res://Icons/Left_menu/ServerS_icon_left_menu.png",
		"system_state_icon" : "res://Icons/Left_menu/System_condition_icon_left_menu.png",
		"single_server_icon" : "res://Icons/Left_menu/Server_icon_left_menu.png"
	},
	"animals" : {
		"orca" : "res://Icons/Animals/Orca_62.png",
		"seal" : "res://Icons/Animals/seal_62.png",
		"bear" : "res://Icons/Animals/bear_62.png"
	},
	
	"log_out_icon" : "res://Icons/Left_menu/Log_out.png"
}
@onready var servernames : Array = [
	"Сервер 1",
	"Сервер 2",
	"Сервер 3"
]


# Called when the node enters the scene tree for the first time.
func _ready():
	settings_tree.set_column_expand(1, true)
	settings_tree.set_column_expand_ratio(1, 100)
	
	#Create main node
	var name_settings_tree : TreeItem = settings_tree.create_item()
	name_settings_tree.set_text(1, "Настройки")
	name_settings_tree.set_selectable(1, false)
	name_settings_tree.disable_folding = true #disable folding
	name_settings_tree.set_custom_font_size(1, 28)

	
	var section_settings_tree = name_settings_tree.create_child() #create child node in main node (named as sub_node)
	section_settings_tree.set_text(0, "Пользователи")  #set data
	section_settings_tree.set_icon(0, load(icons.section_settings.user_icon)) #set icon from texture
	section_settings_tree.disable_folding = true
	
	#create another one node in main node with overriding prevous creation
	section_settings_tree = name_settings_tree.create_child()
	section_settings_tree.set_text(1, "Роли")
	section_settings_tree.set_icon(1, load(icons.section_settings.role_icon))
	section_settings_tree.disable_folding = true
	
	
	section_settings_tree = name_settings_tree.create_child()
	section_settings_tree.set_text(1, "Модели")
	section_settings_tree.set_icon(1, load(icons.section_settings.model_icon))
	section_settings_tree.disable_folding = true
	
	
	var subsection_settings_tree = section_settings_tree.create_child() #in model node create sub nodes
	subsection_settings_tree.set_text(1, "Рестарты")
	subsection_settings_tree.set_icon(1, load(icons.section_settings.restart_icon))
	
	subsection_settings_tree = section_settings_tree.create_child()
	subsection_settings_tree.set_text(1, "Видеокадры")
	subsection_settings_tree.set_icon(1, load(icons.section_settings.screen_icon))
	
	subsection_settings_tree = section_settings_tree.create_child()
	subsection_settings_tree.set_text(1, "Сценарии")
	subsection_settings_tree.set_icon(1, load(icons.section_settings.scenario_icon))
	
	section_settings_tree = name_settings_tree.create_child()
	section_settings_tree.set_text(1, "Серверы")
	section_settings_tree.set_icon(1, load(icons.section_settings.server_icon))
	
	section_settings_tree = name_settings_tree.create_child()
	section_settings_tree.set_text(1, "Состояние системы")
	section_settings_tree.set_icon(1, load(icons.section_settings.system_state_icon))
	
	pass # Replace with function body.
	
	#setup column with servername expanding
	#st.set_column_expand(0, true)
	#st.set_column_expand_ratio(0, 0)
	#setup column with user list expanding
	servers_tree.set_column_expand(0, true)
	servers_tree.set_column_expand_ratio(0, 100)
	
	var name_servers_tree: TreeItem = servers_tree.create_item()
	name_servers_tree.set_text(0, "Серверы")
	name_servers_tree.set_selectable(0, false)
	name_servers_tree.disable_folding = true
	name_servers_tree.set_custom_font_size(0, 28)
	
	var section_servers_tree : TreeItem 
	for i in range(3):
		section_servers_tree = name_servers_tree.create_child() #create child node in main node (named as sub_node)
		section_servers_tree.set_text(0, servernames[i])
		section_servers_tree.set_selectable(0, false)
		section_servers_tree.set_icon(0, load(icons.section_settings.single_server_icon))
				
		#create sub icons for status showing
		section_servers_tree.set_selectable(1, false)
		section_servers_tree.set_icon(1, load(icons.server_state.values()[i]))

		
		#create connected users in loop
		var users: TreeItem = null;
		for j in range(6):
			users = section_servers_tree.create_child()
			users.set_selectable(0, false)
			users.set_text(0, "User Userovich Userovsky " + str(j))
			users.set_icon(0, load(icons.animals.values()[i]))
			
	pass # Replace with function body.
	
	
	login_tree.set_column_expand(0, true)
	login_tree.set_column_expand_ratio(0, 100)
	var login : TreeItem = login_tree.create_item()
	login.set_text(0, "Фамилия Имя Отчество")
	login.set_icon(0, load(icons.section_settings.user_icon))
	login.set_icon(1, load(icons.log_out_icon))
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_mouse_entered():
	$HBoxContainer/VBoxContainer/Close_or_open_menu.visible = true
	pass # Replace with function body.
	
func _on_button_mouse_exited():
	$HBoxContainer/VBoxContainer/Close_or_open_menu.visible = false
	pass # Replace with function body.
	


func _on_close_or_open_menu_toggled(button_pressed):
	if(button_pressed) :
		$HBoxContainer/Panel.visible = false
		
	else:
		$HBoxContainer/Panel.visible = true
	pass # Replace with function body.
