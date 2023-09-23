extends Control

@onready var CONNECT_LINES : Dictionary = {
	"H_Avatar" : [$Right_menu/Main/Block_Avatar/Block/Block_text/Avatar_H],
	"H_Block" : [$Right_menu/Main/Block_Avatar/Block/Block_text/Block_H],
	"H_UserName" : [$Right_menu/Main/User_name_placeholder/Name_edit/Hs_User_name, $Right_menu/Main/User_name_placeholder/Name_edit/HL_User_name],
	"H_UserLogin" : [$Right_menu/Main/User_login_placeholder/Login_edit/Hs_login, $Right_menu/Main/User_login_placeholder/Login_edit/HL_login],
	"H_UserPassword" : [$Right_menu/Main/User_password_placeholder/Password_edit/Hs_password,$Right_menu/Main/User_password_placeholder/Password_edit/HL_password],
	"H_UserRole" : [$Right_menu/Main/User_role_placeholder/Roles/Role1/Hs_role, $Right_menu/Main/User_role_placeholder/Roles/Role1/HL_role],
	"V_UserName" : [$Right_menu/Main/User_name_placeholder/Name_edit/V_User_name],
	"H_Save" : [$Right_menu/Main/Save_Cancel_Delete/Save/H_Save],
	"H_Cancel" : [$Right_menu/Main/Save_Cancel_Delete/Cancel/H_Cancel],
	"H_Delete" : [$Right_menu/Main/Save_Cancel_Delete/Delete/H_Delete],
	"V_UserLogin" : [$Right_menu/Main/User_login_placeholder/Login_edit/V_login],
	"V_UserPassword" : [$Right_menu/Main/User_password_placeholder/Password_edit/V_password],
	"V_UserRole" : [$Right_menu/Main/User_role_placeholder/Roles/Role1/V_role],
	"V_Save" : [$Right_menu/Main/Save_Cancel_Delete/Save/V_Save],
	"V_Cancel" : [$Right_menu/Main/Save_Cancel_Delete/Cancel/V_Cancel],
	"V_Delete" : [$Right_menu/Main/Save_Cancel_Delete/Delete/V_Delete]
}

@onready var BUTTONS : Dictionary = {
	"ChooseAvatar" : $Right_menu/Main/Block_Avatar/Avatar/Avatar/Drop,
	"Block" : $Right_menu/Main/Block_Avatar/Block/Block_button,
	"NameHolder" : $Right_menu/Main/User_name_placeholder/Name_edit,
	"LoginHolder" : $Right_menu/Main/User_login_placeholder/Login_edit,
	"PasswordHolder" : $Right_menu/Main/User_password_placeholder/Password_edit,
	"RoleHolder" : [$Right_menu/Main/User_role_placeholder/Roles/Role1, $Right_menu/Main/User_role_placeholder/Roles/Role2, $Right_menu/Main/User_role_placeholder/Roles/Role3],
	"Save" : $Right_menu/Main/Save_Cancel_Delete/Save,
	"Cancel" : $Right_menu/Main/Save_Cancel_Delete/Cancel,
	"Delete" : $Right_menu/Main/Save_Cancel_Delete/Delete
}

@onready var BUTTONS_ARRAY : Array = [
	ButtonDto.new("Block", null, "H_Block"),
	ButtonDto.new("ChooseAvatar", null, "H_Avatar"),
	ButtonDto.new("NameHolder", "V_UserName", "H_UserName"),
	ButtonDto.new("LoginHolder", "V_UserLogin", "H_UserLogin"),
	ButtonDto.new("PasswordHolder", "V_UserPassword", "H_UserPassword"),
	ButtonDto.new("RoleHolder", "V_UserRole", "H_UserRole"),
	ButtonDto.new("Save", "V_Save", "H_Save"),
	ButtonDto.new("Cancel", "V_Cancel", "H_Cancel"),
	ButtonDto.new("Delete", "V_Delete", "H_Delete")
	]

@onready var rightMenuService: RightMenuService = RightMenuService.new(CONNECT_LINES, BUTTONS)



func _on_block_button_toggled(button_pressed):
	if (button_pressed):
		rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[0])
	else:
		rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[0])



func _on_drop_toggled(button_pressed):
	if (button_pressed):
		rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[1])
	else:
		rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[1])



func _on_name_edit_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[2])

func _on_name_edit_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[2])



func _on_login_edit_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[3])

func _on_login_edit_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[3])



func _on_password_edit_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[4])

func _on_password_edit_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[4])



func _on_role_1_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[5])

func _on_role_1_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[5])



func _on_role_2_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[5])

func _on_role_2_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[5])



func _on_role_3_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[5])

func _on_role_3_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[5])



func _on_save_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[6])

func _on_save_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[6])

func _on_save_mouse_entered():
	rightMenuService.paintRightMenuMouseEnteredButton(BUTTONS_ARRAY[6])

func _on_save_mouse_exited():
	rightMenuService.paintRightMenuMouseExitedButton(BUTTONS_ARRAY[6], BUTTONS_ARRAY)

func _on_save_pressed():
	rightMenuService.paintRightMenuPressedButton(BUTTONS_ARRAY[6])



func _on_cancel_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[7])

func _on_cancel_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[7])

func _on_cancel_mouse_entered():
	rightMenuService.paintRightMenuMouseEnteredButton(BUTTONS_ARRAY[7])

func _on_cancel_mouse_exited():
	rightMenuService.paintRightMenuMouseExitedButton(BUTTONS_ARRAY[7], BUTTONS_ARRAY)

func _on_cancel_pressed():
	rightMenuService.paintRightMenuPressedButton(BUTTONS_ARRAY[7])



func _on_delete_focus_entered():
	rightMenuService.paintRightMenuDeleteFocusEnteredButton(BUTTONS_ARRAY[8])

func _on_delete_focus_exited():
	rightMenuService.paintRightMenuDeleteFocusExitedButton(BUTTONS_ARRAY[8])

func _on_delete_mouse_entered():
	rightMenuService.paintRightMenuDeleteMouseEnteredButton(BUTTONS_ARRAY[8])

func _on_delete_mouse_exited():
	rightMenuService.paintRightMenuDeleteMouseExitedButton(BUTTONS_ARRAY[8], BUTTONS_ARRAY)

func _on_delete_pressed():
	rightMenuService.paintRightMenuDeletePressedButton(BUTTONS_ARRAY[8])
