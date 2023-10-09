extends Node
class_name UsersInfoDto

var userIcon
var userName
var userLogin
var userRole
var userId

func _init(_userIcon, _userName, _userLogin, _userRole, _userId):
	userIcon = _userIcon
	userName = _userName
	userLogin = _userLogin
	userRole = _userRole
	userId = _userId
