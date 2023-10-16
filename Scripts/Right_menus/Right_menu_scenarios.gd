extends Control

@onready var CONNECT_LINES : Dictionary = {
	"H_Master" : [$Right_menu/Main/Master_load/Master/Master_text/Master_H],
	"H_Load" : [$Right_menu/Main/Master_load/Master/Master_text/Load_H],
	"H_Name" : [$Right_menu/Main/Scenario_name_placeholder/Name_edit/Hs_Scenario_name, $Right_menu/Main/Scenario_name_placeholder/Name_edit/HL_Scenario_name],
	"V_Name" : [$Right_menu/Main/Scenario_name_placeholder/Name_edit/V_Scenario_name],
	"H_ConnectedModel" : [$Right_menu/Main/Connected_model_placeholder/Space/Hs_model, $Right_menu/Main/Connected_model_placeholder/Space/HL_model],
	"V_ConnectedModel" : [$Right_menu/Main/Connected_model_placeholder/Space/V_model],
	"H_Author" : [$Right_menu/Main/Author_placeholder/Author_edit/Hs_author, $Right_menu/Main/Author_placeholder/Author_edit/HL_author],
	"V_Author" : [$Right_menu/Main/Author_placeholder/Author_edit/V_author],
	"H_LoadDate" : [$Right_menu/Main/Load_date_placeholder/Load_date_edit/Hs_load_date, $Right_menu/Main/Load_date_placeholder/Load_date_edit/HL_load_date],
	"V_LoadDate" : [$Right_menu/Main/Load_date_placeholder/Load_date_edit/V_load_date],
	"H_Save" : [$Right_menu/Main/Save_Cancel_Delete/Save/H_Save],
	"H_Cancel" : [$Right_menu/Main/Save_Cancel_Delete/Cancel/H_Cancel],
	"H_Delete" : [$Right_menu/Main/Save_Cancel_Delete/Delete/H_Delete],
	"V_Save" : [$Right_menu/Main/Save_Cancel_Delete/Save/V_Save],
	"V_Cancel" : [$Right_menu/Main/Save_Cancel_Delete/Cancel/V_Cancel],
	"V_Delete" : [$Right_menu/Main/Save_Cancel_Delete/Delete/V_Delete]
}

@onready var BUTTONS : Dictionary = {
	"Master" : $Right_menu/Main/Master_load/Master/Master,
	"Load" : $Right_menu/Main/Master_load/Load/Load/Load,
	"NameHolder" : $Right_menu/Main/Scenario_name_placeholder/Name_edit,
	"ConnectedModelHolder" : $Right_menu/Main/Connected_model_placeholder/Scroll/For_ident/Models/Model1,
	"AuthorHolder" : $Right_menu/Main/Author_placeholder/Author_edit,
	"LoadDateHolder" : $Right_menu/Main/Load_date_placeholder/Load_date_edit,
	"Save" : $Right_menu/Main/Save_Cancel_Delete/Save,
	"Cancel" : $Right_menu/Main/Save_Cancel_Delete/Cancel,
	"Delete" : $Right_menu/Main/Save_Cancel_Delete/Delete
}

@onready var BUTTONS_ARRAY : Array = [
	ButtonDto.new("Master", null, "H_Master"),
	ButtonDto.new("Load", null, "H_Load"),
	ButtonDto.new("NameHolder", "V_Name", "H_Name"),
	ButtonDto.new("ConnectedModelHolder", "V_ConnectedModel", "H_ConnectedModel"),
	ButtonDto.new("AuthorHolder", "V_Author", "H_Author"),
	ButtonDto.new("LoadDateHolder", "V_LoadDate", "H_LoadDate"),
	ButtonDto.new("Save", "V_Save", "H_Save"),
	ButtonDto.new("Cancel", "V_Cancel", "H_Cancel"),
	ButtonDto.new("Delete", "V_Delete", "H_Delete")
	]

@onready var rightMenuService: RightMenuService = RightMenuService.new(CONNECT_LINES, BUTTONS)



func _on_master_toggled(button_pressed):
	if (button_pressed):
		rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[0])
	else:
		rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[0])


func _on_load_toggled(button_pressed):
	if (button_pressed):
		rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[1])
	else:
		rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[1])


func _on_name_edit_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[2])

func _on_name_edit_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[2])


func _on_model_1_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[3])

func _on_model_1_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[3])


func _on_model_2_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[3])

func _on_model_2_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[3])


func _on_model_3_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[3])

func _on_model_3_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[3])


func _on_model_4_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[3])

func _on_model_4_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[3])


func _on_author_edit_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[4])

func _on_author_edit_focus_exited():
	rightMenuService.paintRightMenuFocusExitedButton(BUTTONS_ARRAY[4])



func _on_load_date_edit_focus_entered():
	rightMenuService.paintRightMenuFocusEnteredButton(BUTTONS_ARRAY[5])

func _on_load_date_edit_focus_exited():
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
