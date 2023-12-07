extends Control

@onready var CONNECT_LINES : Dictionary = {
	"H_Control" : [$Right_menu/Main/Control/Control/Control_text/Control_H],
	"H_Name" : [$Right_menu/Main/Server_name_placeholder/Name_edit/Hs_Server_name, $Right_menu/Main/Server_name_placeholder/Name_edit/HL_Server_name],
	"V_Name" : [$Right_menu/Main/Server_name_placeholder/Name_edit/V_Server_name],
	"H_ConnectedModel" : [$Right_menu/Main/Connected_model_placeholder2/Space/Hs_model, $Right_menu/Main/Connected_model_placeholder2/Space/HL_model],
	"V_ConnectedModel" : [$Right_menu/Main/Connected_model_placeholder2/Space/V_model],
	"H_AllowedRoles" : [$Right_menu/Main/Allowed_roles_placeholder2/Space/Hs_role, $Right_menu/Main/Allowed_roles_placeholder2/Space/HL_role],
	"V_AllowedRoles" : [$Right_menu/Main/Allowed_roles_placeholder2/Space/V_role],
	"H_AllowedUsers" : [$Right_menu/Main/Allowed_users_placeholder2/Space/Hs_User, $Right_menu/Main/Allowed_users_placeholder2/Space/HL_User],
	"V_AllowedUsers" : [$Right_menu/Main/Allowed_users_placeholder2/Space/V_User],
	"H_Author" : [$Right_menu/Main/Server_author_placeholder/author_edit/Hs_author_name, $Right_menu/Main/Server_author_placeholder/author_edit/HL_author_name],
	"V_Author" : [$Right_menu/Main/Server_author_placeholder/author_edit/V_author_name],
	"H_LoadDate" : [$Right_menu/Main/Server_load_date_placeholder/Load_date_edit/Hs_load_date, $Right_menu/Main/Server_load_date_placeholder/Load_date_edit/HL_load_date],
	"V_LoadDate" : [$Right_menu/Main/Server_load_date_placeholder/Load_date_edit/V_load_date],
	"H_DataExchange" : [$Right_menu/Main/Server_data_exchange_placeholder/Data_exchange_edit/Hs_Data_exchange, $Right_menu/Main/Server_data_exchange_placeholder/Data_exchange_edit/HL_Data_exchange],
	"V_DataExchange" : [$Right_menu/Main/Server_data_exchange_placeholder/Data_exchange_edit/V_Data_exchange],
	"H_Save" : [$Right_menu/Main/Save_Cancel_Delete/Save/H_Save],
	"H_Cancel" : [$Right_menu/Main/Save_Cancel_Delete/Cancel/H_Cancel],
	"H_Delete" : [$Right_menu/Main/Save_Cancel_Delete/Delete/H_Delete],
	"V_Save" : [$Right_menu/Main/Save_Cancel_Delete/Save/V_Save],
	"V_Cancel" : [$Right_menu/Main/Save_Cancel_Delete/Cancel/V_Cancel],
	"V_Delete" : [$Right_menu/Main/Save_Cancel_Delete/Delete/V_Delete]
}

@onready var BUTTONS : Dictionary = {
	"ControlButtons" : $Right_menu/Main/Control/Control/Control_buttons/Inizialization_button,
	"NameHolder" : $Right_menu/Main/Server_name_placeholder/Name_edit,
	"ConnectedModelHolder" : $Right_menu/Main/Connected_model_placeholder2/Scroll/For_ident/Models/Model1,
	"AllowedRole" : $Right_menu/Main/Allowed_roles_placeholder2/Scroll/For_ident/Roles/Role1,
	"AllowedUser" : $Right_menu/Main/Allowed_users_placeholder2/Scroll/For_ident/Users/User1,
	"AuthorHolder" : $Right_menu/Main/Server_author_placeholder/author_edit,
	"LoadDateHolder" : $Right_menu/Main/Server_load_date_placeholder/Load_date_edit,
	"DataExchange" : $Right_menu/Main/Server_data_exchange_placeholder/Data_exchange_edit,
	"Save" : $Right_menu/Main/Save_Cancel_Delete/Save,
	"Cancel" : $Right_menu/Main/Save_Cancel_Delete/Cancel,
	"Delete" : $Right_menu/Main/Save_Cancel_Delete/Delete
}

@onready var BUTTONS_ARRAY : Array = [
	ButtonDto.new("ControlButtons", null, "H_Control"),
	ButtonDto.new("NameHolder", "V_Name", "H_Name"),
	ButtonDto.new("ConnectedModelHolder", "V_ConnectedModel", "H_ConnectedModel"),
	ButtonDto.new("AllowedRole", "V_AllowedRoles", "H_AllowedRoles"),
	ButtonDto.new("AllowedUser", "V_AllowedUsers", "H_AllowedUsers"),
	ButtonDto.new("AuthorHolder", "V_Author", "H_Author"),
	ButtonDto.new("LoadDateHolder", "V_LoadDate", "H_LoadDate"),
	ButtonDto.new("DataExchange", "V_DataExchange", "H_DataExchange"),
	ButtonDto.new("Save", "V_Save", "H_Save"),
	ButtonDto.new("Cancel", "V_Cancel", "H_Cancel"),
	ButtonDto.new("Delete", "V_Delete", "H_Delete")
	]

@onready var rightMenuService: RightMenuService = RightMenuService.new(CONNECT_LINES, BUTTONS)



func _on_inizialization_button_toggled(button_pressed):
	if (button_pressed):
		rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[0])
	else:
		rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[0])


func _on_play_button_toggled(button_pressed):
	if (button_pressed):
		rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[0])
	else:
		rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[0])


func _on_step_button_toggled(button_pressed):
	if (button_pressed):
		rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[0])
	else:
		rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[0])


func _on_pause_button_toggled(button_pressed):
	if (button_pressed):
		rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[0])
	else:
		rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[0])


func _on_stop_button_toggled(button_pressed):
	if (button_pressed):
		rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[0])
	else:
		rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[0])


func _on_name_edit_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[1])

func _on_name_edit_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[1])


func _on_model_1_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[2])

func _on_model_1_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[2])


func _on_model_2_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[2])

func _on_model_2_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[2])



func _on_model_3_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[2])

func _on_model_3_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[2])


func _on_model_4_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[2])

func _on_model_4_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[2])


func _on_role_1_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[3])

func _on_role_1_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[3])


func _on_role_2_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[3])

func _on_role_2_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[3])


func _on_role_3_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[3])

func _on_role_3_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[3])


func _on_role_4_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[3])

func _on_role_4_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[3])


func _on_user_1_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[4])

func _on_user_1_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[4])


func _on_user_2_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[4])

func _on_user_2_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[4])


func _on_user_3_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[4])

func _on_user_3_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[4])


func _on_user_4_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[4])

func _on_user_4_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[4])


func _on_author_edit_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[5])

func _on_author_edit_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[5])


func _on_load_date_edit_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[6])

func _on_load_date_edit_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[6])


func _on_data_exchange_edit_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[7])

func _on_data_exchange_edit_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[7])



func _on_save_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[8])

func _on_save_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[8])

func _on_save_mouse_entered():
	rightMenuService.paintRightMenuMouseEnteredButton(BUTTONS_ARRAY[8])

func _on_save_mouse_exited():
	rightMenuService.paintRightMenuMouseExitedButton(BUTTONS_ARRAY[8], BUTTONS_ARRAY)

func _on_save_pressed():
	rightMenuService.paintRightMenuPressedButton(BUTTONS_ARRAY[8])



func _on_cancel_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[9])

func _on_cancel_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[9])

func _on_cancel_mouse_entered():
	rightMenuService.paintRightMenuMouseEnteredButton(BUTTONS_ARRAY[9])

func _on_cancel_mouse_exited():
	rightMenuService.paintRightMenuMouseExitedButton(BUTTONS_ARRAY[9], BUTTONS_ARRAY)

func _on_cancel_pressed():
	rightMenuService.paintRightMenuPressedButton(BUTTONS_ARRAY[9])



func _on_delete_focus_entered():
	rightMenuService.paintRightMenuDeleteFocusEnteredButton(BUTTONS_ARRAY[10])

func _on_delete_focus_exited():
	rightMenuService.paintRightMenuDeleteFocusExitedButton(BUTTONS_ARRAY[10])

func _on_delete_mouse_entered():
	rightMenuService.paintRightMenuDeleteMouseEnteredButton(BUTTONS_ARRAY[10])

func _on_delete_mouse_exited():
	rightMenuService.paintRightMenuDeleteMouseExitedButton(BUTTONS_ARRAY[10], BUTTONS_ARRAY)

func _on_delete_pressed():
	rightMenuService.paintRightMenuDeletePressedButton(BUTTONS_ARRAY[10])
