extends Control

@onready var CONNECT_LINES : Dictionary = {
	"H_Avatar" : [$Right_menu/Main/Avatar/Panel_for_icon/Avatar_H],
	"H_RoleName" : [$Right_menu/Main/Role_name_placeholder/Name_edit/Hs_Role_name, $Right_menu/Main/Role_name_placeholder/Name_edit/HL_Role_name],
	"V_RoleName" : [$Right_menu/Main/Role_name_placeholder/Name_edit/V_Role_name],
	"H_RightsGroup1" : [$Right_menu/Main/Role_rights/Role_rights/HL_role, $Right_menu/Main/Role_rights_placeholder/Rights_groups/Groups_of_rights/Group_of_rights1/Group_of_rights_name/H_group_role, $Right_menu/Main/Role_rights_placeholder/Rights_groups/Groups_of_rights/Group_of_rights1/Group_of_rights_name/H_rights],
	"V_RightsGroup1" : [$Right_menu/Main/Role_rights/Role_rights/V_role, $Right_menu/Main/Role_rights_placeholder/Rights_groups/Groups_of_rights/Group_of_rights1/Group_of_rights_name/V_group_role, $Right_menu/Main/Role_rights_placeholder/Rights_groups/Groups_of_rights/Group_of_rights1/Group_of_rights_name/V_rights]
}

@onready var BUTTONS : Dictionary = {
	"ChooseAvatar" : $Right_menu/Main/Avatar/Avatar/Avatar/Drop,
	"NameHolder" : $Right_menu/Main/Role_name_placeholder/Name_edit,
	"RoleRightGroup1Holder" : $Right_menu/Main/Role_rights_placeholder/Rights_groups/Groups_of_rights/Group_of_rights1/Group_of_rights_name
}

@onready var BUTTONS_ARRAY : Array = [
	ButtonDto.new("ChooseAvatar", null, "H_Avatar"),
	ButtonDto.new("NameHolder", "V_RoleName", "H_RoleName"),
	ButtonDto.new("RoleRightGroup1Holder", "V_RightsGroup1", "H_RightsGroup1")
	]

@onready var rightMenuService: RightMenuService = RightMenuService.new(CONNECT_LINES, BUTTONS)





func _on_drop_toggled(button_pressed):
	if (button_pressed):
		rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[0])
	else:
		rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[0])



func _on_name_edit_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[1])

func _on_name_edit_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[1])






func _on_group_of_rights_name_toggled(button_pressed):
	if (button_pressed):
		rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[2])
	else:
		rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[2])


func _on_right_1_toggled(button_pressed):
	if (button_pressed):
		rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[2])
	else:
		rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[2])

