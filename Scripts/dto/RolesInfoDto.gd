extends Node
class_name RolesInfoDto

var roleIcon
var roleName
var roleRights
var roleId

func _init(_roleIcon, _roleName, _roleRights, _roleId):
	roleIcon = _roleIcon
	roleName = _roleName
	roleRights = _roleRights
	roleId = _roleId
