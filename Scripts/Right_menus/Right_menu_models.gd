extends Control

@onready var CONNECT_LINES : Dictionary = {
	"H_Load" : [$Right_menu/Main/Load/Panel_for_icon/Load_H],
	"H_ModelName" : [$Right_menu/Main/Model_name_placeholder/Name_edit/Hs_model_name, $Right_menu/Main/Model_name_placeholder/Name_edit/HL_model_name],
	"V_ModelName" : [$Right_menu/Main/Model_name_placeholder/Name_edit/V_model_name],
	"H_ControlSum" : [$Right_menu/Main/Model_control_sum_placeholder/Control_sum_edit/Hs_Control_sum, $Right_menu/Main/Model_control_sum_placeholder/Control_sum_edit/HL_Control_sum],
	"V_ControlSum" : [$Right_menu/Main/Model_control_sum_placeholder/Control_sum_edit/V_Control_sum],
	"H_Author" : [$Right_menu/Main/Model_author_placeholder/author_edit/Hs_model_author, $Right_menu/Main/Model_author_placeholder/author_edit/HL_model_author],
	"V_Author" : [$Right_menu/Main/Model_author_placeholder/author_edit/V_model_author],
	"H_LoadDate" : [$Right_menu/Main/Model_load_date_placeholder/Load_date_edit/Hs_Load_date, $Right_menu/Main/Model_load_date_placeholder/Load_date_edit/HL_Load_date],
	"V_LoadDate" : [$Right_menu/Main/Model_load_date_placeholder/Load_date_edit/V_Load_date],
	"H_Save" : [$Right_menu/Main/Save_Cancel_Delete/Save/H_Save],
	"V_Save" : [$Right_menu/Main/Save_Cancel_Delete/Save/V_Save],
	"H_Cancel" : [$Right_menu/Main/Save_Cancel_Delete/Cancel/H_Cancel],
	"V_Cancel" : [$Right_menu/Main/Save_Cancel_Delete/Cancel/V_Cancel],
	"H_Delete" : [$Right_menu/Main/Save_Cancel_Delete/Delete/H_Delete],
	"V_Delete" : [$Right_menu/Main/Save_Cancel_Delete/Delete/V_Delete]
	
}

@onready var BUTTONS : Dictionary = {
	"Load" : $Right_menu/Main/Load/Load/Load/Load,
	"NameHolder" : $Right_menu/Main/Model_name_placeholder/Name_edit,
	"ControlSumHolder" : $Right_menu/Main/Model_control_sum_placeholder/Control_sum_edit,
	"AuthorHolder" : $Right_menu/Main/Model_author_placeholder/author_edit,
	"LoadDateHolder" : $Right_menu/Main/Model_load_date_placeholder/Load_date_edit,
	"Save" : $Right_menu/Main/Save_Cancel_Delete/Save,
	"Cancel" : $Right_menu/Main/Save_Cancel_Delete/Cancel,
	"Delete" : $Right_menu/Main/Save_Cancel_Delete/Delete
}

@onready var BUTTONS_ARRAY : Array = [
	ButtonDto.new("Load", null, "H_Load"),
	ButtonDto.new("NameHolder", "V_ModelName", "H_ModelName"),
	ButtonDto.new("ControlSumHolder", "V_ControlSum", "H_ControlSum"),
	ButtonDto.new("AuthorHolder", "V_Author", "H_Author"),
	ButtonDto.new("LoadDateHolder", "V_LoadDate", "H_LoadDate"),
	ButtonDto.new("Save", "V_Save", "H_Save"),
	ButtonDto.new("Cancel", "V_Cancel", "H_Cancel"),
	ButtonDto.new("Delete", "V_Delete", "H_Delete")
	]

@onready var rightMenuService: RightMenuService = RightMenuService.new(CONNECT_LINES, BUTTONS)



func _on_load_toggled(button_pressed):
	if (button_pressed):
		rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[0])
	else:
		rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[0])



func _on_name_edit_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[1])

func _on_name_edit_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[1])


func _on_control_sum_edit_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[2])

func _on_control_sum_edit_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[2])


func _on_author_edit_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[3])

func _on_author_edit_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[3])


func _on_load_date_edit_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[4])

func _on_load_date_edit_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[4])


func _on_save_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[5])

func _on_save_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[5])

func _on_save_mouse_entered():
	rightMenuService.paintRightMenuMouseEnteredButton(BUTTONS_ARRAY[5])

func _on_save_mouse_exited():
	rightMenuService.paintRightMenuMouseExitedButton(BUTTONS_ARRAY[5], BUTTONS_ARRAY)

func _on_save_pressed():
	rightMenuService.paintRightMenuPressedButton(BUTTONS_ARRAY[5])



func _on_cancel_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[6])

func _on_cancel_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[6])

func _on_cancel_mouse_entered():
	rightMenuService.paintRightMenuMouseEnteredButton(BUTTONS_ARRAY[6])

func _on_cancel_mouse_exited():
	rightMenuService.paintRightMenuMouseExitedButton(BUTTONS_ARRAY[6], BUTTONS_ARRAY)

func _on_cancel_pressed():
	rightMenuService.paintRightMenuPressedButton(BUTTONS_ARRAY[6])



func _on_delete_focus_entered():
	rightMenuService.paintRightMenuDeleteFocusEnteredButton(BUTTONS_ARRAY[7])

func _on_delete_focus_exited():
	rightMenuService.paintRightMenuDeleteFocusExitedButton(BUTTONS_ARRAY[7])

func _on_delete_mouse_entered():
	rightMenuService.paintRightMenuDeleteMouseEnteredButton(BUTTONS_ARRAY[7])

func _on_delete_mouse_exited():
	rightMenuService.paintRightMenuDeleteMouseExitedButton(BUTTONS_ARRAY[7], BUTTONS_ARRAY)

func _on_delete_pressed():
	rightMenuService.paintRightMenuDeletePressedButton(BUTTONS_ARRAY[7])
